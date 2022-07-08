<!-- region Generated -->
# secops:radare2

Examine files with hash, strings and imported funtions for malware analysis.

## Metadata

- Tags:
  - Malware
  - IR
  - Radare2
  - Windows
- Language: via Radare2
- Supported Operating Systems:
  - Windows

## Parameters

- Parameters
  - Type: String
  - IsOptional: True
  - DefaultValue: -A -qc it -qc ia -qc sI -qc i
- Add strings output
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: false
- Scanned file filename and path
  - Type: String
  - IsOptional: True
  - DefaultValue: ..\..\..\runner.exe
- Output as json
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: true
<!-- endregion -->
