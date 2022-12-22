<!-- region Generated -->
# secops:falco:addRule

Adds a new rule to Falco.

## Metadata

- Tags:
  - Falco
- Language: Bash
- Supported Operating Systems:
  - Linux

## Parameters

- Rules
  - Description: Rule in YAML format.
  - Type: String
  - IsOptional: False
  - DefaultValue: 
- Rule path
  - Description: If exists, will append
  - Type: String
  - IsOptional: True
  - DefaultValue: 
- Replace rules file
  - Description: If checked, will replace the rule file if exists.
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: 
- Do not add to rules list
  - Description: If checked, the file will not be added to the rules list.
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: 
- Load first
  - Description: If checked, will put the new rule at the top of the rule list.
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: 
- Restart Service
  - Description: If checked, will restart the Falco service.
  - Type: Boolean
  - IsOptional: False
  - DefaultValue: True
<!-- endregion -->
