<!-- region Generated -->
# windows:gpupdate

Updates multiple Group Policy settings.

## Metadata

- Tags:
  - Utilities
  - gpupdate
  - Windows
- Language: Executable
- Supported Operating Systems:
  - Windows

## Parameters

- Target
  - Description: Computer or User
  - Type: String
  - IsOptional: True
  - DefaultValue: 
- Force
  - Description: Replaces all policy settings instead of just ones that have changed.
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: 
- Custom Parameters
  - Description: If edited, this take precedence over all other parameters.
  - Type: String
  - IsOptional: True
  - DefaultValue: /Force
<!-- endregion -->
