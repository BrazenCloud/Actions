
import subprocess
import re
import json

class CConnection:
    def __init__(self):
        self.local_address = ''
        self.local_port = ''
        self.remote_address = ''
        self.process = ''
    
class CNetstat :
    def __init__(self):
        self.connections = []

settings_file = 0
    
# if the user made settings in the job editor, they will be in the following json file

settings_file = open("..//settings.json", "r")
settings = json.load(settings_file);

use_filter = "false"
filter_setting = ""
filter_regex = ".*"

if(settings_file):
    # filter netstat information to a specific address pattern
    if("Use Filter" in settings):
        use_filter = settings["Use Filter"];
    if("IP Filter" in settings):
        filter_setting = settings["IP Filter"];

if(use_filter == "true"):
    if(filter_setting):
        filter_regex = ".*" + filter_setting + ".*";
    
output_object = CNetstat()

proc = subprocess.Popen(["netstat", "-patu", "--numeric-ports", "--numeric-hosts", "--numeric-users"], stdout=subprocess.PIPE)

r1 = "tcp\\s+([0-9]+)\\s+([0-9]+)\\s+([0-9\\.]+):([0-9]+)\\s+([0-9\\.]+):([\\*0-9]+)\\s+\\w+\\s+([0-9]*)"

for rline in iter(proc.stdout.readline, b''):
    line = rline.rstrip().decode('utf-8')
    # print('f-' + line)
    r1m = re.search(r1, line)
    if(r1m):
        # print('r1 match:' + ' local: ' + r1m.group(3) + ' '  + r1m.group(4) + ' remote: ' + r1m.group(5) + ' ' + r1m.group(6) + ' process: ' + r1m.group(7))
        
        remote_address = r1m.group(5)
        f1m = re.search(filter_regex, remote_address)
        if(use_filter == "false" or f1m):
            # we found the IP of interest
            connection_object = CConnection()
            connection_object.local_address = r1m.group(3)
            connection_object.local_port = r1m.group(4)
            connection_object.remote_address = r1m.group(5)
            connection_object.process = r1m.group(7)
        
            output_object.connections.append(connection_object)

#print(len(output_object.connections))
json_output = json.dumps(output_object, default=lambda x: x.__dict__)
print(json_output)


    
