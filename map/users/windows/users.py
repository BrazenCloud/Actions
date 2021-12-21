
import os
import sys
#import uuid
import subprocess
import re
import json

# these class structures are going to be converted to json at the bottom of the script
# be sure to get the casing correct
class CDataPair:
    def __init__(self):
        self.name = "default"
        self.value = ''
                 
class CUserAccount :
    def __init__(self):
        self.accountData = []
      
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

# you can use this general pattern for any wmic query
proc = subprocess.Popen(["wmic", "useraccount", "list", "/translate:nocomma", "/format:csv"], stdout=subprocess.PIPE)

def save_datapair(target_array, name, value):
    print('saving data pair: ' + name + ' ' + value)
    data_pair = CDataPair()
    data_pair.name = name
    data_pair.value = value
    target_array.append(data_pair)

line_index = 0;
for rline in iter(proc.stdout.readline, b''):
    line = rline.rstrip()
    print('wmic line ' + str(line_index) + ' output string: ' + line)    
    column_data = line.split(',')
    # this is just to make sure we don't parse the header line
    if(len(column_data) >= 13 and column_data[1] != 'AccountType'):
        account = CUserAccount()
        save_datapair(account.accountData, "accounttype", column_data[1])
        save_datapair(account.accountData, "description", column_data[2])
        save_datapair(account.accountData, "domain", column_data[4])
        save_datapair(account.accountData, "name", column_data[9])
        save_datapair(account.accountData, "sid", column_data[13])
        output_object.userAccounts.append(account)        
    line_index = line_index + 1

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



