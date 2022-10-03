<!-- region Generated -->
# runway:stream:listen

Listens for a Runway Stream

## Metadata

- Tags:
  - Windows
  - Runway
  - Stream
  - DEMO
- Language: PowerShell
- Supported Operating Systems:
  - Windows
  - Linux

## Parameters

- Stream Name
  - Description: The name of the stream to listen for.
  - Type: String
  - IsOptional: False
- Output Type
  - Description: The type of connection to make.
  - Type: String
  - IsOptional: False
  - DefaultValue: tcp, pipe, or file
- Address
  - Description: The address of the connection to make. Depends on the 'Input Type'
  - Type: String
  - IsOptional: False
  - DefaultValue: 
- Timeout
  - Description: The timeout for the stream.
  - Type: String
  - IsOptional: True
  - DefaultValue: 15m
<!-- endregion -->
