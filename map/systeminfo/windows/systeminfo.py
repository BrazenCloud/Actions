
import os
import sys
import uuid
from ctypes import *

import subprocess
import re
import json

class CDataPair:
    def __init__(self):
        self.name = "default"
        self.value = ''
                                 
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

class SearchPair:
    def __init__(self, name, expression, start):
        self.name = name
        self.expression = expression
        self.start = start
        
sysinfo_searches = []

sysinfo_searches.append(SearchPair("hostname", "Host Name:\s+([\w-]+)", 0))
sysinfo_searches.append(SearchPair("osname", "OS Name:\s+([\w\s-]+)", 0))
sysinfo_searches.append(SearchPair("osversion", "OS Version:\s+([\w\s\-\.\/]+)", 0))

# if the user made settings in the job editor, they will be in the following json file
#
settings_file = open("..\\settings.json", "r")
settings = json.load(settings_file);
print(settings)    
    
output_object = CAssetMap()
endpoint_object = CAssetMapEndpoint()

proc = subprocess.Popen(["systeminfo.exe"], stdout=subprocess.PIPE)

for rline in iter(proc.stdout.readline, b''):
    line = rline.rstrip()
    print('f-' + line)
    for spair in sysinfo_searches:
        match = re.search(spair.expression, line[spair.start:])
        if(match):
            print('match:' + match.group(1))
            data_pair = CDataPair()
            data_pair.name = spair.name
            data_pair.value = match.group(1)
            endpoint_object.systemInfo.append(data_pair)

output_object.endpointData.append(endpoint_object)

json_output = json.dumps(output_object, default=lambda x: x.__dict__)
print(json_output)

f = open("..\\results\\output.json", "w+")
f.write(json_output)
f.close()

update_setting = "false"
host = ""

if(settings.has_key("Update Assets")):
    update_setting = settings["Update Assets"];

if(settings.has_key("host")):
    host = settings["host"];

if update_setting == "true":
    if host != "":
        runway_proc = subprocess.Popen(["runway.exe", "-N", "-S", host, "upload", "--map", "..\\results\\output.json"])
    else:
        runway_proc = subprocess.Popen(["runway.exe", "-N", "upload", "--map", "..\\results\\output.json"])
    runway_proc.wait()
