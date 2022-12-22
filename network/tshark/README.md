<!-- region Generated -->
# network:tshark

Run a network sniffer using TShark.

## Metadata

- Tags:
  - Network
  - Sniffer
  - PCAP
- Language: PowerShell
- Supported Operating Systems:
  - Windows

## Parameters

- Interface Index
  - Description: Index of the interface to sniff
  - Type: Number
  - IsOptional: False
  - DefaultValue: 4
- Output File
  - Description: 
  - Type: String
  - IsOptional: False
  - DefaultValue: output.pcap
- Auto Stop Condition
  - Description: Stop when duration:SEC, filesize:KB, files:COUNT, or packets:NUM
  - Type: String
  - IsOptional: False
  - DefaultValue: duration:10
- Buffer
  - Description: Switch to next file when duration:SEC, filesize:KB, files:COUNT, packets:COUNT, interval:SEC
  - Type: String
  - IsOptional: False
  - DefaultValue: duration:5
<!-- endregion -->
