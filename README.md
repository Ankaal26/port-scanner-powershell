# Port Scanner (Windows) — PowerShell

Description
- Simple, visual port scanner for Windows written in PowerShell.
- Scans individual ports, comma-separated lists or ranges. Displays results in the console and can save them to a TXT file.

Author & License
- Author: Anass K
- License: Free to use, copy and modify.
- No warranty is provided.


Requirements
- Windows 10/11 or Windows Server with PowerShell.
- Permissions to run scripts (may require ExecutionPolicy Bypass).
- Network connectivity to the target host(s).

Files
- PortScanner.ps1 — main script (place it in the same folder as this README).

Basic usage
- Run from PowerShell (run as Administrator if required):
  powershell -ExecutionPolicy Bypass -File .\PortScanner.ps1 -HostTarget <host|IP> -Ports <ports>

Parameters
- -HostTarget (string, optional): Target host or IP. Default: "localhost".
- -Ports (string, optional): Ports to scan. Supported formats:
  - Comma-separated list: 22,80,443
  - Range: 1-1024
  - Default value: 21,22,80,443,3389,8080
- Internal timeout: ~1 second per connection attempt (configured in the script).

Behavior
- Attempts a TCP connection for each port with ~1s timeout.
- Console output: OPEN (green) or CLOSED/timeout (red).
- Shows a summary with total open, closed and scanned ports.
- Prompts to save results to a TXT file; if accepted, generates a file named:
  scan_<host>_YYYYMMDD_HHMMSS.txt

Examples
- Quick scan of localhost with default ports:
  powershell -ExecutionPolicy Bypass -File .\PortScanner.ps1
- Scan specific ports:
  powershell -ExecutionPolicy Bypass -File .\PortScanner.ps1 -HostTarget 192.168.1.10 -Ports 22,80,443
- Scan a port range:
  powershell -ExecutionPolicy Bypass -File .\PortScanner.ps1 -HostTarget 10.0.0.5 -Ports 1-1024

Security & Legal Notes
- Only scan systems you own or have explicit permission to test.
- Scanning may trigger IDS/IPS, firewalls and generate audit logs.
- Adjust ExecutionPolicy and permissions according to your environment policies.

Suggested improvements (optional)
- Add concurrency to speed up large range scans.
- Support CSV/JSON output formats.
- Add a parameter to adjust per-port timeout.

Contact

- For questions or improvements, open an issue or PR in this repository (if applicable).
