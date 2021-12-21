
import os
import sys
import subprocess
import re
import json

class CArpCache:
    def __init__(self):
        self.ipAddress = ''
        self.macAddress = ''
        self.type = ''

class CNetworkInterface :
    def __init__(self):
        self.dnsName = ''
        self.ipAddress = ''
        self.macAddress = ''
        self.gatewayAddress = ''
        self.index = ''
        self.arpcache = []

class CAssetMapEndpoint:
    def __init__(self):
        self.uniqueFingerprint = "self"
        self.ipAddress = ""
        self.macAddress = ""
        self.endpointType = ""
        self.systemInfo = []
        self.interfaces = []
        self.userAccounts = []

class CAssetMap :
    def __init__(self):
        self.endpointData = []

settings_file = 0
    
# if the user made settings in the job editor, they will be in the following json file
try:
    settings_file = open("..\\settings.json", "r")
    settings = json.load(settings_file);
    print(settings)    
except IOError:
    print('..\\settings.json not found')
   
output_object = CAssetMapEndpoint()
output_map = CAssetMap()

proc = subprocess.Popen(["arp", "-a", "-v"], stdout=subprocess.PIPE)

current_interface = 0
for rline in iter(proc.stdout.readline, b''):
    line = rline.rstrip()
    print('n-' + line)

    # new interface group?
    interface_match = re.search("Interface: ([\w\.]+) --- ([\w]+)", line)
    if(interface_match):

        # save the old group?
        if(current_interface):
            output_object.interfaces.append(current_interface)
            current_interface = 0
        # end if current_interface

        # init new group
        current_interface = CNetworkInterface()
        current_interface.address = interface_match.group(1)
        current_interface.index = interface_match.group(2)
    # end if interface_match

    # working on a group?
    if(current_interface):

        # entries with no MAC address
        match_1 = re.search("^\s+([\w\.]+)\s+([\w]+)$", line)
        if(match_1):
            cache = CArpCache()
            cache.ipAddress = match_1.group(1)
            cache.type = match_1.group(2)
            current_interface.arpcache.append(cache)
            continue
        
        # entires with MAC address
        match_2 = re.search("^\s+([\w\.]+)\s+([\w\-]+)\s+([\w]+)$", line)
        if(match_2):
            cache = CArpCache()
            cache.ipAddress = match_2.group(1)
            cache.macAddress = match_2.group(2)
            cache.type = match_2.group(3)
            current_interface.arpcache.append(cache)
            continue
    # end if current_interface

# end for rline

# one last group left behind?
if(current_interface):
    output_object.interfaces.append(current_interface)
    current_interface = 0

output_map.endpointData.append(output_object)

json_output = json.dumps(output_map, default=lambda x: x.__dict__)
print(json_output)

f = open("..\\results\\output.json", "w+")
f.write(json_output)
f.close()

# use the various settings if they were supplied
update_setting = "false"
host = ""

if(settings_file):
    if(settings.has_key("Update Assets")):
        update_setting = settings["Update Assets"];
    if(settings.has_key("host")):
        host = settings["host"];
    
# this is how to use runway.exe to upload data to the server
if update_setting == "true":
    if host != "":
        runway_proc = subprocess.Popen(["runway.exe", "-N", "-S", host, "upload", "--map", "..\\results\\output.json"])
    else:
        runway_proc = subprocess.Popen(["runway.exe", "-N", "upload", "--map", "..\\results\\output.json"])
    runway_proc.wait()


