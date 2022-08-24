<!-- region Generated -->
# windows:tracert

Runs the tracert command.

## Metadata

- Tags:
  - Utilities
  - tracert
  - Windows
- Language: Executable
- Supported Operating Systems:
  - Windows

## Parameters

- Skip Resolving
  - Description: Do not resolve addresses to hostnames
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: 
- Max hops
  - Description: Maximum number of hops to search for target.
  - Type: String
  - IsOptional: True
  - DefaultValue: 
- timeout
  - Description: Wait timeout milliseconds for each reply.
  - Type: String
  - IsOptional: True
  - DefaultValue: 
- Target Name
  - Description: The destination of the route trace
  - Type: String
  - IsOptional: True
  - DefaultValue: 
- Custom Parameters
  - Description: If edited, this take precedence over all other parameters.
  - Type: String
  - IsOptional: True
  - DefaultValue: -d brazencloud.com
<!-- endregion -->
