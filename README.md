# BrazenCloud Actions

This repository is host to all of the Actions for BrazenCloud. These are all open source, so feel free to import them into your BrazenCloud tenant for your use.

If you are interested in getting a BrazenCloud demo account, please reach out: [info@brazencloud.com](mailto:info@brazencloud.com)

## Action Development

To understand how an Action in BrazenCloud works, please refer to our [Action Developer Guide](https://docs.runway.host/runway-documentation/action-developer-guides/overview).

You'll also notice several `*.ActionBuilder.json` files within the repository. Those are configurations for our [Action Builder](https://github.com/BrazenCloud/ActionBuilder). This allows us to generate simple actions with a straightforward configuration file.

## Deploying an Action to BrazenCloud

To understand how to deploy Actions from a Git repository into BrazenCloud, see our [CI/CD Guide](https://docs.runway.host/runway-documentation/action-developer-guides/cicd) or, if you are feeling adventurous, feel free to look at our [GitHub workflow definitions here on Github](.github/workflows/).

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
- aws
  - [aws:installToolsModules](aws/installToolsModules)
  - [aws:s3:getBucketEncryption](aws/s3/getBucketEncryption)
  - [aws:s3:getBuckets](aws/s3/getBuckets)
  - [aws:s3:setBucketEncryption](aws/s3/setBucketEncryption)
  - [aws:setCredentialProfile](aws/setCredentialProfile)
- brazencloudIndex
  - [brazencloudIndex:group](brazencloudIndex/group)
- demo
  - [demo:sql:ExportDB](demo/sql/ExportDB)
  - [demo:sql:ImportDB](demo/sql/ImportDB)
- deploy
  - [deploy:msi](deploy/msi)
  - [deploy:runway](deploy/runway)
- download
  - [download:brazencloudIndex](download/brazencloudIndex)
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
  - [endpoint:GetServices](endpoint/GetServices)
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
  - [inventory:discoveredAssets](inventory/discoveredAssets)
  - [inventory:dnscache](inventory/dnscache)
  - [inventory:eventLogs](inventory/eventLogs)
  - [inventory:netstat](inventory/netstat)
  - [inventory:nmap](inventory/nmap)
  - [inventory:osquery](inventory/osquery)
  - [inventory:services](inventory/services)
  - [inventory:tasklog](inventory/tasklog)
- map
  - [map:arpcache](map/arpcache)
  - [map:discover](map/discover)
  - [map:systeminfo](map/systeminfo)
  - [map:users](map/users)
- network
  - [network:tshark](network/tshark)
- powershell
  - [powershell:InstallModules](powershell/InstallModules)
  - [powershell:RunCommand](powershell/RunCommand)
  - [powershell:SetExecPolicy](powershell/SetExecPolicy)
- runway
  - [runway:brazenAgent:harden](runway/brazenAgent/harden)
  - [runway:stream:connect](runway/stream/connect)
  - [runway:stream:listen](runway/stream/listen)
- secops
  - [secops:aide-chk-update](secops/aide-chk-update)
  - [secops:aide-install](secops/aide-install)
  - [secops:BriMorLRC](secops/BriMorLRC)
  - [secops:CDIR](secops/CDIR)
  - [secops:CDIRwParams](secops/CDIRwParams)
  - [secops:chkrootkit](secops/chkrootkit)
  - [secops:cobaltstrikescan](secops/cobaltstrikescan)
  - [secops:CyLR](secops/CyLR)
  - [secops:debsums](secops/debsums)
  - [secops:falco:addRule](secops/falco/addRule)
  - [secops:falco:configure](secops/falco/configure)
  - [secops:falco:getOutputFile](secops/falco/getOutputFile)
  - [secops:falco:install:debian](secops/falco/install/debian)
  - [secops:falco:install:rhel](secops/falco/install/rhel)
  - [secops:fierce](secops/fierce)
  - [secops:GBCBA_win](secops/GBCBA_win)
  - [secops:GBCRA_win](secops/GBCRA_win)
  - [secops:ioc-scanner](secops/ioc-scanner)
  - [secops:lastActivityView](secops/lastActivityView)
  - [secops:loki_memory](secops/loki_memory)
  - [secops:lynis](secops/lynis)
  - [secops:nikto](secops/nikto)
  - [secops:pecmd](secops/pecmd)
  - [secops:raccoon](secops/raccoon)
  - [secops:radare2](secops/radare2)
  - [secops:rkhunter](secops/rkhunter)
  - [secops:tih](secops/tih)
  - [secops:turboscanner](secops/turboscanner)
  - [secops:winpmem](secops/winpmem)
  - [secops:yara_general](secops/yara_general)
  - [secops:yara_ransomware](secops/yara_ransomware)
  - [secops:yum](secops/yum)
  - [secops:yum-verify](secops/yum-verify)
- template
  - [template:bash](template/bash)
  - [template:batch](template/batch)
  - [template:binary](template/binary)
  - [template:parameters](template/parameters)
  - [template:powershell](template/powershell)
  - [template:python](template/python)
  - [template:python27-32](template/python27-32)
  - [template:python37-32](template/python37-32)
  - [template:yara](template/yara)
- upload
  - [upload:file](upload/file)
- windows
  - [windows:chkdsk](windows/chkdsk)
  - [windows:driverquery](windows/driverquery)
  - [windows:dsregcmd](windows/dsregcmd)
  - [windows:gpresult](windows/gpresult)
  - [windows:gpupdate](windows/gpupdate)
  - [windows:ipconfig](windows/ipconfig)
  - [windows:netsh](windows/netsh)
  - [windows:nslookup](windows/nslookup)
  - [windows:ping](windows/ping)
  - [windows:quser](windows/quser)
  - [windows:qwinsta](windows/qwinsta)
  - [windows:reg](windows/reg)
  - [windows:sfc](windows/sfc)
  - [windows:tasklist](windows/tasklist)
  - [windows:tracert](windows/tracert)
<!-- endregion -->
