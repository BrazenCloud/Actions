<!-- region Generated -->
# runway:stream:connect

Connects to a Runway Stream

## Metadata

- Tags:
  - Windows
  - Runway
  - Stream
  - DEMO
- Language: PowerShell
- Supported Operating Systems:
  - Windows

## Parameters

- Stream Name
  - Description: The name of the stream to connect to.
  - Type: String
  - IsOptional: False
- Output Type
  - Description: The type of connection to make.
  - Type: String
  - IsOptional: False
  - DefaultValue: tcp, pipe, or file
- Address
  - Description: The address of the connection to make. Depends on the 'Output Type'
  - Type: String
  - IsOptional: False
  - DefaultValue: 
- Timeout
  - Description: The timeout for the stream.
  - Type: String
  - IsOptional: True
  - DefaultValue: 15m
<!-- endregion -->
