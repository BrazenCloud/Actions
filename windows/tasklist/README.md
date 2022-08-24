<!-- region Generated -->
# windows:tasklist

This tool displays a list of currently running processes on either a local or remote machine.

## Metadata

- Tags:
  - Utilities
  - tasklist
  - Windows
- Language: Executable
- Supported Operating Systems:
  - Windows

## Parameters

- Show Services
  - Description: Displays services hosted in each process.
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: 
- Output Format
  - Description: Specifies the output format. Valid values: TABLE, LIST, CSV.
  - Type: String
  - IsOptional: True
  - DefaultValue: 
- Filter
  - Description: Displays a set of tasks that match a given criteria specified by the filter.
  - Type: String
  - IsOptional: True
  - DefaultValue: 
- Custom Parameters
  - Description: If edited, this take precedence over all other parameters.
  - Type: String
  - IsOptional: True
  - DefaultValue: /FO CSV
<!-- endregion -->
