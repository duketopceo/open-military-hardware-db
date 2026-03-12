import type { Express, Request, Response } from "express";
import { createServer, type Server } from "http";
import http from "http";

// Simple proxy function to forward requests to FastAPI
function proxyToFastAPI(req: Request, res: Response) {
  const options = {
    hostname: "127.0.0.1",
    port: 8000,
    path: req.originalUrl,
    method: req.method,
    headers: { ...req.headers, host: "127.0.0.1:8000" },
  };

  const proxyReq = http.request(options, (proxyRes) => {
    res.writeHead(proxyRes.statusCode || 500, proxyRes.headers);
    proxyRes.pipe(res);
  });

  proxyReq.on("error", () => {
    res.status(502).json({ detail: "Backend unavailable" });
  });

  req.pipe(proxyReq);
}

export async function registerRoutes(
  httpServer: Server,
  app: Express
): Promise<Server> {
  // Proxy all API requests to FastAPI on port 8000
  // Express v5 uses path-to-regexp v8 which uses {*param} syntax
  app.use("/api/v1", (req, res) => {
    proxyToFastAPI(req, res);
  });
  app.get("/health", proxyToFastAPI);

  return httpServer;
}
