<!-- region Generated -->
# windows:sfc

Scans the integrity of all protected system files and replaces incorrect versions with correct Microsoft versions.

## Metadata

- Tags:
  - Utilities
  - sfc
  - Windows
- Language: Executable
- Supported Operating Systems:
  - Windows

## Parameters

- Scan
  - Description: Scans integrity of all protected system files and repairs files with problems when possible.
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: 
- Verify Only
  - Description: Scans integrity of all protected system files. No repair operation is performed.
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: 
- Scan File
  - Description: Scans integrity of the referenced file, repairs file if problems are identified. Specify full path <file>
  - Type: String
  - IsOptional: True
  - DefaultValue: 
- Verify File
  - Description: Verifies the integrity of the file with full path <file>.  No repair operation is performed.
  - Type: String
  - IsOptional: True
  - DefaultValue: 
- Custom Parameters
  - Description: If edited, this take precedence over all other parameters.
  - Type: String
  - IsOptional: True
  - DefaultValue: /SCANNOW
<!-- endregion -->
