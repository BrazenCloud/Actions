<!-- region Generated -->
# ad:report:filter

Filter AD Reports to create additional reports.

## Metadata

- Tags:
  - Windows
  - PowerShell
  - ActiveDirectory
  - Reporting
- Language: PowerShell
- Supported Operating Systems:
  - Windows

## Parameters

- Report to filter
  - Description: The report name to find in the previous action results
  - Type: String
  - IsOptional: False
  - DefaultValue: users
- Filters
  - Description: PowerShell Where-Object filters seperated by commas.
  - Type: String
  - IsOptional: False
- CSV Out
  - Description: Will write the results as a CSV
  - Type: Boolean
  - IsOptional: True
<!-- endregion -->
