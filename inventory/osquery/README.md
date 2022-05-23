<!-- region Generated -->
# inventory:osquery

Run osquery on the host.

## Metadata

- Tags:
  - Osquery
  - Windows
- Language: via osquery binary
- Supported Operating Systems:
  - Windows

## Parameters

- Query
  - Type: String
  - IsOptional: False
  - DefaultValue: .all startup_items
- Format for Elastic
  - Description: When selected, will format the output to send to Elastic.
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: false
- Query Name
  - Type: String
  - IsOptional: True
  - DefaultValue: RunwayQuery
<!-- endregion -->
