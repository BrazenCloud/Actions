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
  - Description: The number of most recent events to pull.
  - Type: Number
  - IsOptional: True
  - DefaultValue: 100
- Wait Time in Minutes
  - Description: The number of minutes to listen for new events.
  - Type: Number
  - IsOptional: True
  - DefaultValue: 10
- XPath Query
  - Type: String
  - IsOptional: True
  - DefaultValue: *[System[(EventID=4625)]]
<!-- endregion -->
