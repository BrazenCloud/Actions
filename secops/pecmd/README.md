<!-- region Generated -->
# secops:pecmd

Collect the prefetch cache from Windows systems.

## Metadata

- Tags:
  - IR
  - Executable
  - PECmd
  - Windows
- Language: Executable
- Supported Operating Systems:
  - Windows

## Parameters

- Directory
  - Description: Directory to process
  - Type: String
  - IsOptional: True
  - DefaultValue: 
- File
  - Description: File to process
  - Type: String
  - IsOptional: True
  - DefaultValue: 
- Custom Parameters
  - Description: Parameters typed here are passed directly to the command.
  - Type: String
  - IsOptional: True
  - DefaultValue: -d 'C:\Windows\Prefetch' --json ..\results\ --jsonf pecmdresults.json
<!-- endregion -->
