<!-- region Generated -->
# elastic:winLogBeat

Uses WinLogBeat to collect event logs.

## Metadata

- Tags:
  - Events
  - EventLog
  - Windows
  - Elastic
  - WinLogBeat
- Language: PowerShell
- Supported Operating Systems:
  - Windows

## Parameters

- Event Log Names
  - Description: If left as 'default', the default winlogbeat event log configuration is used.
  - Type: String
  - IsOptional: False
  - DefaultValue: default
- Tail Time in Minutes
  - Type: Number
  - IsOptional: True
  - DefaultValue: 60
- Stream
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: 
- Stream Name
  - Type: String
  - IsOptional: True
  - DefaultValue: 
- Elastic Url
  - Type: String
  - IsOptional: True
  - DefaultValue: localhost:9200
- Wait Time in Minutes
  - Type: Number
  - IsOptional: True
  - DefaultValue: 10
- Elastic User Name
  - Type: String
  - IsOptional: True
  - DefaultValue: elastic
- Elastic User Password
  - Type: Password
  - IsOptional: True
  - DefaultValue: 
<!-- endregion -->
