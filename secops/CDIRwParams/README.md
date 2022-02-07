<!-- region Generated -->
# secops:CDIRwParams

CDIR (Cyber Defense Institute Incident Response) Collector - live collection tool based on OSS tool/library

## Metadata

- Tags:
  - IR
  - Collection
- Language: C++
- Supported Operating Systems:
  - Windows

## Parameters

- MemoryDump
  - Description: Collect data from the CDIR MemoryDump collector?
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: true
- MFT
  - Description: Collect data from the CDIR MFT collector?
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: true
- Secure
  - Description: Collect data from the CDIR Secure collector?
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: true
- UsnJrnl
  - Description: Collect data from the CDIR UsnJrnl collector?
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: true
- EventLog
  - Description: Collect data from the CDIR EventLog collector?
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: true
- Prefetch
  - Description: Collect data from the CDIR Prefetch collector?
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: true
- Registry
  - Description: Collect data from the CDIR Registry collector?
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: true
- WMI
  - Description: Collect data from the CDIR WMI collector?
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: true
- SRUM
  - Description: Collect data from the CDIR SRUM collector?
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: true
- Web
  - Description: Collect data from the CDIR Web collector?
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: true
- MemoryDumpCmdline
  - Description: Command line with which to run the memory dump.
  - Type: String
  - IsOptional: True
  - DefaultValue: winpmem-2.1.post4.exe --output RAM.aff4
- Target
  - Description: The target drive.
  - Type: String
  - IsOptional: True
  - DefaultValue: C:\
<!-- endregion -->
