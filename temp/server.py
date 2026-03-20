"""
Temporary dev server for the test UI.
Run from project root: python temp/server.py
Serves temp/ as static files and /api/platforms.json from data/json/platforms.json.
"""
import json
import os
from pathlib import Path
from http.server import HTTPServer, SimpleHTTPRequestHandler

PROJECT_ROOT = Path(__file__).resolve().parent.parent
TEMP_DIR = PROJECT_ROOT / "temp"
DATA_JSON = PROJECT_ROOT / "data" / "json" / "platforms.json"


class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(TEMP_DIR), **kwargs)

    def do_GET(self):
        if self.path == "/api/platforms.json" or self.path == "/api/platforms":
            self.send_response(200)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            if DATA_JSON.exists():
                with open(DATA_JSON, encoding="utf-8") as f:
                    self.wfile.write(f.read().encode("utf-8"))
            else:
                self.wfile.write(b"[]")
            return
        return SimpleHTTPRequestHandler.do_GET(self)

    def log_message(self, format, *args):
        print("[%s] %s" % (self.log_date_time_string(), format % args))


def main():
    os.chdir(TEMP_DIR)
    port = 8765
    server = HTTPServer(("127.0.0.1", port), Handler)
    print(f"Temp UI: http://127.0.0.1:{port}")
    print("Press Ctrl+C to stop.")
    server.serve_forever()


if __name__ == "__main__":
    main()
