# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

1. **Do NOT open a public issue.**
2. Email **kimballluke@gmail.com** with:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
3. You will receive a response within 48 hours.
4. A fix will be prioritized and released as a patch version.

## Security Practices

- All secrets stored in `.env` files (never committed to git)
- Dependencies scanned weekly via Dependabot
- CodeQL security scanning on every push
- Input validation on all user-facing endpoints
- Parameterized database queries (no SQL injection)
- HTTPS enforced in production
