"""
Structured logging configuration using structlog.

Usage:
    from logging_config import configure_logging, get_logger

    configure_logging()  # Call once at app startup
    log = get_logger()

    log.info("processing_order", order_id="ORD-1234", items=3)
    log.warning("rate_limit_approaching", endpoint="/api/v1/data", usage_pct=85)
    log.error("payment_failed", order_id="ORD-1234", error="card_declined")

Environment Variables:
    APP_ENV: Set to "production" for JSON output (default: development/console)
    LOG_LEVEL: DEBUG, INFO, WARNING, ERROR, CRITICAL (default: INFO)
"""

import logging
import os
import sys

import structlog


def configure_logging():
    """Configure structlog for the application.
    
    - Development: Human-readable console output with colors
    - Production: JSON output for log aggregation services
    """
    is_prod = os.environ.get("APP_ENV") == "production"
    level = getattr(logging, os.environ.get("LOG_LEVEL", "INFO").upper(), logging.INFO)

    processors = [
        structlog.contextvars.merge_contextvars,
        structlog.processors.add_log_level,
        structlog.processors.StackInfoRenderer(),
        structlog.dev.set_exc_info,
        structlog.processors.TimeStamper(fmt="iso"),
    ]

    if is_prod:
        processors.append(structlog.processors.dict_tracebacks)
        processors.append(structlog.processors.JSONRenderer())
    else:
        processors.append(structlog.dev.ConsoleRenderer())

    structlog.configure(
        processors=processors,
        wrapper_class=structlog.make_filtering_bound_logger(level),
        context_class=dict,
        logger_factory=structlog.PrintLoggerFactory(sys.stderr),
        cache_logger_on_first_use=is_prod,
    )


def get_logger(**initial_context):
    """Get a structured logger with optional initial context.
    
    Args:
        **initial_context: Key-value pairs to bind to all log entries
                          from this logger (e.g., module="auth", service="api")
    
    Returns:
        A structlog bound logger
    """
    log = structlog.get_logger()
    if initial_context:
        log = log.bind(**initial_context)
    return log
