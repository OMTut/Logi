#!/usr/bin/env python3
"""
Local test server for testing Logi update functionality.
Serves the test version.json and installer file.
"""

import http.server
import socketserver
import os
import sys
from pathlib import Path

class UpdateTestHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/version.json':
            # Serve the test version.json
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            
            with open('test_version.json', 'rb') as f:
                self.wfile.write(f.read())
                
        elif self.path == '/LogiSetup.exe':
            # Serve the installer from the installer/output directory
            installer_path = Path('../../installer/output/LogiSetup.exe')
            if installer_path.exists():
                self.send_response(200)
                self.send_header('Content-Type', 'application/octet-stream')
                self.send_header('Content-Disposition', 'attachment; filename="LogiSetup.exe"')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                
                with open(installer_path, 'rb') as f:
                    while True:
                        chunk = f.read(8192)
                        if not chunk:
                            break
                        self.wfile.write(chunk)
            else:
                self.send_error(404, "Installer not found. Run installer build first.")
        else:
            # Default behavior for other requests
            super().do_GET()
    
    def log_message(self, format, *args):
        # Custom logging
        print(f"[TEST SERVER] {format % args}")

def main():
    PORT = 8080
    
    # Change to the test directory
    test_dir = Path(__file__).parent
    os.chdir(test_dir)
    
    print(f"🧪 Starting Logi Update Test Server on port {PORT}")
    print(f"📁 Serving from: {test_dir.absolute()}")
    print(f"🔗 Test endpoints:")
    print(f"   Version: http://localhost:{PORT}/version.json")
    print(f"   Installer: http://localhost:{PORT}/LogiSetup.exe")
    print(f"💡 Press Ctrl+C to stop the server")
    print()
    
    # Check if installer exists
    installer_path = Path('../../installer/output/LogiSetup.exe')
    if installer_path.exists():
        print(f"✅ Installer found: {installer_path.absolute()}")
    else:
        print(f"⚠️  Installer not found: {installer_path.absolute()}")
        print(f"   Run 'installer\\build_installer_inno.bat' first")
    print()
    
    try:
        with socketserver.TCPServer(("", PORT), UpdateTestHandler) as httpd:
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Test server stopped")
    except OSError as e:
        if e.errno == 10048:  # Address already in use
            print(f"❌ Port {PORT} is already in use. Stop other servers or use a different port.")
        else:
            print(f"❌ Error starting server: {e}")

if __name__ == "__main__":
    main()