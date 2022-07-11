<!-- region Generated -->
# inventory:nmap

Use Nmap to port scan the local host, also installs nmap from apt-get if not installed.

## Metadata

- Tags:
  - Inventory
  - Portscan
  - Network
  - Nmap
  - Linux
- Language: via cmdline
- Supported Operating Systems:
  - Linux

## Parameters

- Network Subnet
  - Type: String
  - IsOptional: True
  - DefaultValue: 192.168.0.0/24
- Ports to scan
  - Type: String
  - IsOptional: True
  - DefaultValue: -p 0-65535
- Max rate packets per second
  - Type: String
  - IsOptional: True
  - DefaultValue: --max-rate 50
<!-- endregion -->
