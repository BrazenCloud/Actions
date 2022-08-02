<!-- region Generated -->
# secops:aide-chk-update

Install Aide file integrity monitoring, initialize and update the database.

## Metadata

- Tags:
  - AIDE
  - Inventory
  - File Integrity
  - Files
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
  - DefaultValue: --max-rate 5
<!-- endregion -->
