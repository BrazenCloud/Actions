<!-- region Generated -->
# ad:users:new

Creates a user in Active Directory

## Metadata

- Tags:
  - Windows
  - PowerShell
  - ActiveDirectory
  - User
- Language: PowerShell
- Supported Operating Systems:
  - Windows

## Parameters

- Password Length
  - Description: How long the random password should be.
  - Type: Number
  - IsOptional: True
  - DefaultValue: 12
- Change Password At Logon
  - Description: If checked, password is set to force a password change at first logon.
  - Type: Boolean
  - IsOptional: True
  - DefaultValue: true
- GivenName
  - Description: The value for the GivenName property for the new user.
  - Type: String
  - IsOptional: True
- Surname
  - Description: The value for the Surname property for the new user.
  - Type: String
  - IsOptional: True
- Name
  - Description: The value for the Name property for the new user.
  - Type: String
  - IsOptional: True
- SamAccountName
  - Description: The value for the SamAccountName property for the new user.
  - Type: String
  - IsOptional: True
- UserPrincipalName
  - Description: The value for the UserPrincipalName property for the new user.
  - Type: String
  - IsOptional: True
<!-- endregion -->
