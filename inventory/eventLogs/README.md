<!-- region Generated -->
# inventory:eventLogs

Collects events from the Windows event logs

## Metadata

- Tags:
  - Events
  - EventLog
  - Windows
- Language: PowerShell
- Supported Operating Systems:
  - Windows

## Parameters

- Event Log Name
  - Type: String
  - IsOptional: False
  - DefaultValue: Security
- Tail Count
  - Type: Number
  - IsOptional: True
  - DefaultValue: 100
- Wait Time in Minutes
  - Type: Number
  - IsOptional: True
  - DefaultValue: 10
- XPath Query
  - Type: String
  - IsOptional: True
  - DefaultValue: *[System[(EventID=4625)]]
<!-- endregion -->
