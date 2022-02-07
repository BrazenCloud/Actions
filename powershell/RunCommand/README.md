<!-- region Generated -->
# powershell:RunCommand

Runs a PowerShell Command, designed to work with Invoke-RwPowerShellCommand from the SDK.

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
  - DefaultValue: false
- Serialize Depth
  - Description: When serializing the return object, how deep should it go?
  - Type: Number
  - IsOptional: False
  - DefaultValue: 2
- Default Properties Only
  - Description: Selects default properties. Only works on objects with formats.
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: false
<!-- endregion -->
