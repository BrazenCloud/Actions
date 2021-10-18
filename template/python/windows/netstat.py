
import subprocess
import re
import json

#from urllib import urlencode
import urllib2
import ssl

class CConnection:
    def __init__(self):
        self.local_address = ''
        self.local_port = ''
        self.remote_address = ''
        self.process = ''
    
class CNetstat :
    def __init__(self):
        self.connections = []

#
# if the user made settings in the job editor, they will be in the following json file
#
settings_file = open("..\\settings.json", "r")
settings = json.load(settings_file);

# filter netstat information to a specific address pattern
filter_setting = settings["IP Filter"];
filter_regex = ".*" + filter_setting + ".*";
    
output_object = CNetstat()

proc = subprocess.Popen(["netstat.exe", "-ano"], stdout=subprocess.PIPE)

r1 = "  TCP\s+([0-9\.]+):([0-9]+)\s+([0-9\.]+):([0-9]+)\s+\w+\s+([0-9]*)"

for rline in iter(proc.stdout.readline, b''):
    line = rline.rstrip()
    #print('f-' + line)
    r1m = re.search(r1, line)
    if(r1m):
        #print('r1 match:' + ' local: ' + r1m.group(1) + ' '  + r1m.group(2) + ' remote: ' + r1m.group(3) + ' ' + r1m.group(4) + ' process: ' + r1m.group(5))
        
        remote_address = r1m.group(3)
        f1m = re.search(filter_regex, remote_address)
        if(f1m):
            # we found the IP of interest
            connection_object = CConnection()
            connection_object.local_address = r1m.group(1)
            connection_object.local_port = r1m.group(2)
            connection_object.remote_address = r1m.group(3)
            connection_object.process = r1m.group(5)
        
            output_object.connections.append(connection_object)

#print(len(output_object.connections))
json_output = json.dumps(output_object, default=lambda x: x.__dict__)
print(json_output)

# uncomment this to submit to api
# request = urllib2.Request('https://127.0.0.1:5001/api/testapi/mapsubmit')
# request.add_header('Content-Type', 'application/json')

# none of this was needed to get the POST to work
#request.add_header('Content-Type', 'application/json; charset=utf-8')
#json_output_asbytes = json_output.encode('utf-8')   # needs to be bytes
#request.add_header('Content-Length', len(json_output_asbytes))
#response = urllib.request.urlopen(req, jsondataasbytes)

# WARNING - this disables the SSL cert check - use for DEBUGGING ONLY
# context = ssl._create_unverified_context()
# response = urllib2.urlopen(request, data=json_output, context=context)

# print(response)
