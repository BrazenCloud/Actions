<!-- region Generated -->
# windows:chkdsk

Checks a disk and displays a status report.

## Metadata

- Tags:
  - Utilities
  - chkdsk
  - Windows
- Language: Executable
- Supported Operating Systems:
  - Windows

## Parameters

- Volume
  - Description: Specifies the drive letter (followed by a colon), mount point, or volume name.
  - Type: String
  - IsOptional: True
  - DefaultValue: 
- Scan
  - Description: If specified, passes the /scan parameter
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: 
- Custom Parameters
  - Description: If edited, this take precedence over all other parameters.
  - Type: String
  - IsOptional: True
  - DefaultValue: C: /scan /I /C
<!-- endregion -->
