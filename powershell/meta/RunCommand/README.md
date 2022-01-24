<!-- region Generated -->
# powershell:meta:RunCommand

Runs a PowerShell Command

## Metadata

- Tags:
  - Windows
  - Linux
  - PowerShell
  - Meta
- Language: PowerShell
- Supported Operating Systems:
  - Windows
  - Linux

## Parameters

- Command
  - Description: Execution Policy to apply
  - Type: String
  - IsOptional: False
  - DefaultValue: Get-Process | ?{{Parameters}.Name -eq 'runner'}
- PWSH
  - Description: Use PowerShell 7?
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: 
<!-- endregion -->
