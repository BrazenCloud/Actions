<!-- region Generated -->
# secops:falco:configure

Applies a new yaml config to Falco.

## Metadata

- Tags:
  - Falco
- Language: Bash
- Supported Operating Systems:
  - Linux

## Parameters

- Configuration
  - Description: Configuration in YAML format. Will replace falco.yaml
  - Type: String
  - IsOptional: False
  - DefaultValue: 
- Restart Service
  - Description: If checked, will restart the Falco service.
  - Type: Boolean
  - IsOptional: False
  - DefaultValue: True
<!-- endregion -->
