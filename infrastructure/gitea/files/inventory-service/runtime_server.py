import http.server
import json
import os
import pathlib

APP_NAME = os.getenv("APP_NAME", "inventory-service")
APP_VERSION = pathlib.Path(__file__).parent.joinpath("version.txt").read_text().strip()
APP_ENV = os.getenv("APP_ENV", "dev")
APP_PORT = int(os.getenv("APP_PORT", "8080"))


class AppHandler(http.server.BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        return

    def _send(self, code, body, ct="application/json"):
        enc = body.encode()
        self.send_response(code)
        self.send_header("Content-Type", ct)
        self.send_header("Content-Length", str(len(enc)))
        self.end_headers()
        self.wfile.write(enc)

    def do_GET(self):
        if self.path == "/health":
            self._send(
                200,
                json.dumps(
                    {
                        "status": "ok",
                        "app": APP_NAME,
                        "version": APP_VERSION,
                        "env": APP_ENV,
                    }
                ),
            )
        elif self.path == "/version.txt":
            self._send(
                200,
                f"app={APP_NAME}\nversion={APP_VERSION}\nenv={APP_ENV}\n",
                "text/plain",
            )
        elif self.path == "/":
            self._send(
                200,
                f"<h1>{APP_NAME}</h1><p>Version: {APP_VERSION}</p><p>Env: {APP_ENV}</p>",
                "text/html",
            )
        else:
            self._send(404, json.dumps({"error": "not found"}))


if __name__ == "__main__":
    http.server.HTTPServer(("0.0.0.0", APP_PORT), AppHandler).serve_forever()
