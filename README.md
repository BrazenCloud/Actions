# Runway Actions

This repository is host to all of the Actions for BrzenCloud. These are all open source, so feel free to import them into your BrazenCloud tenant for your use.


## Action Development

To understand how an Action in BrazenCloud works, please refer to our [Action Developer Guide](https://docs.runway.host/runway-documentation/action-developer-guides/overview).

## Deploying an Action to BrzenCloud

To understand how to deploy Actions from a Git repository into BrazenCloud, see our [CI/CD Guide](https://docs.runway.host/runway-documentation/action-developer-guides/cicd)

## Action Table of Contents
<!-- region Generated -->
- ad
  - [ad:computers:get](ad/computers/get)
  - [ad:computers:getFilter](ad/computers/getFilter)
  - [ad:cs:CompleteCSR](ad/cs/CompleteCSR)
  - [ad:cs:CreateCSR](ad/cs/CreateCSR)
  - [ad:cs:SignCSR](ad/cs/SignCSR)
  - [ad:dcs:get](ad/dcs/get)
  - [ad:groups:addMember](ad/groups/addMember)
  - [ad:groups:get](ad/groups/get)
  - [ad:groups:getFilter](ad/groups/getFilter)
  - [ad:groups:getMembers](ad/groups/getMembers)
  - [ad:groups:removeMember](ad/groups/removeMember)
  - [ad:odj:dc](ad/odj/dc)
  - [ad:odj:member](ad/odj/member)
  - [ad:pwPolicies:getDefault](ad/pwPolicies/getDefault)
  - [ad:pwPolicies:getfinegrained](ad/pwPolicies/getfinegrained)
  - [ad:report:combine](ad/report/combine)
  - [ad:report:filter](ad/report/filter)
  - [ad:report:group](ad/report/group)
  - [ad:users:disable](ad/users/disable)
  - [ad:users:enable](ad/users/enable)
  - [ad:users:get](ad/users/get)
  - [ad:users:getFilter](ad/users/getFilter)
  - [ad:users:new](ad/users/new)
  - [ad:users:remove](ad/users/remove)
- demo
  - [demo:sql:ExportDB](demo/sql/ExportDB)
  - [demo:sql:ImportDB](demo/sql/ImportDB)
- deploy
  - [deploy:msi](deploy/msi)
  - [deploy:runway](deploy/runway)
- download
  - [download:combine](download/combine)
  - [download:elastic](download/elastic)
  - [download:file](download/file)
  - [download:syslog](download/syslog)
- elastic
  - [elastic:winLogBeat](elastic/winLogBeat)
- endpoint
  - [endpoint:collectFile](endpoint/collectFile)
  - [endpoint:CreateUpdateRegistryKey](endpoint/CreateUpdateRegistryKey)
  - [endpoint:DeleteRegistryKey](endpoint/DeleteRegistryKey)
  - [endpoint:deployFile](endpoint/deployFile)
  - [endpoint:DisableLocalUserAccount](endpoint/DisableLocalUserAccount)
  - [endpoint:FileDelete](endpoint/FileDelete)
  - [endpoint:GetFreeDiskSpace](endpoint/GetFreeDiskSpace)
  - [endpoint:GetInstalledSoftware](endpoint/GetInstalledSoftware)
  - [endpoint:GetMemoryDump](endpoint/GetMemoryDump)
  - [endpoint:GetOSVersion](endpoint/GetOSVersion)
  - [endpoint:GetProcessMemoryDump](endpoint/GetProcessMemoryDump)
  - [endpoint:GetRunningProcesses](endpoint/GetRunningProcesses)
  - [endpoint:InstallMonitoringTools](endpoint/InstallMonitoringTools)
  - [endpoint:InstallPackage](endpoint/InstallPackage)
  - [endpoint:InstallWindowsPatch](endpoint/InstallWindowsPatch)
  - [endpoint:KillProcess](endpoint/KillProcess)
  - [endpoint:ManageNetworking](endpoint/ManageNetworking)
  - [endpoint:RemoteFileCopy](endpoint/RemoteFileCopy)
  - [endpoint:RunOSQuery](endpoint/RunOSQuery)
  - [endpoint:setServiceLogonAccount](endpoint/setServiceLogonAccount)
- inventory
  - [inventory:accounts](inventory/accounts)
  - [inventory:dnscache](inventory/dnscache)
  - [inventory:eventLogs](inventory/eventLogs)
  - [inventory:netstat](inventory/netstat)
  - [inventory:nmap](inventory/nmap)
  - [inventory:osquery](inventory/osquery)
  - [inventory:tasklog](inventory/tasklog)
- map
  - [map:arpcache](map/arpcache)
  - [map:discover](map/discover)
  - [map:systeminfo](map/systeminfo)
  - [map:users](map/users)
- powershell
  - [powershell:InstallModules](powershell/InstallModules)
  - [powershell:RunCommand](powershell/RunCommand)
  - [powershell:SetExecPolicy](powershell/SetExecPolicy)
- runway
  - [runway:brazenAgent:harden](runway/brazenAgent/harden)
  - [runway:stream:connect](runway/stream/connect)
  - [runway:stream:listen](runway/stream/listen)
- secops
  - [secops:BriMorLRC](secops/BriMorLRC)
  - [secops:CDIR](secops/CDIR)
  - [secops:CDIRwParams](secops/CDIRwParams)
  - [secops:chkrootkit](secops/chkrootkit)
  - [secops:cobaltstrikescan](secops/cobaltstrikescan)
  - [secops:CyLR](secops/CyLR)
  - [secops:debsums](secops/debsums)
  - [secops:fierce](secops/fierce)
  - [secops:lastactivity](secops/lastactivity)
  - [secops:loki_memory](secops/loki_memory)
  - [secops:lynis](secops/lynis)
  - [secops:pecmd](secops/pecmd)
  - [secops:raccoon](secops/raccoon)
  - [secops:radare2](secops/radare2)
  - [secops:rkhunter](secops/rkhunter)
  - [secops:turboscanner](secops/turboscanner)
  - [secops:winpmem](secops/winpmem)
  - [secops:yara_ransomware](secops/yara_ransomware)
  - [secops:yum-verify](secops/yum-verify)
- template
  - [template:batch](template/batch)
  - [template:binary](template/binary)
  - [template:parameters](template/parameters)
  - [template:powershell](template/powershell)
  - [template:python](template/python)
  - [template:python27-32](template/python27-32)
  - [template:python37-32](template/python37-32)
  - [template:yara](template/yara)
<!-- endregion -->
