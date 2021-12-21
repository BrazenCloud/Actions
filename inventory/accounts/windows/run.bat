net user > ..\Results\users.txt
net group "administrators" > ..\Results\admins.txt
net localgroup administrators >> ..\Results\admins.txt
wmic useraccount get /all /format:list >> ..\Results\users.txt
wmic useraccount list full >> ..\Results\users.txt
