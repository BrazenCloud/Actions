
import subprocess
import json

settings_file = 0
    
# if the user made settings in the job editor, they will be in the following json file
try:
    settings_file = open("..\\settings.json", "r")
    settings = json.load(settings_file);
    print(settings)    
except IOError:
    print('..\\settings.json not found')

iprange_setting = ""
enrollment_token = ""

host = ""

if(settings_file):
    if(settings.has_key("host")):
        host = settings["host"];
    if(settings.has_key("IP Range")):
        iprange_setting = settings["IP Range"];
    if(settings.has_key("Enrollment Token")):
        iprange_setting = settings["Enrollment Token"];

if host != "":
    runway_proc = subprocess.Popen(["runway.exe", "-N", "-S", host, "deploy", "-h", iprange_setting, "-t", enrollment_token])
else:
    runway_proc = subprocess.Popen(["runway.exe", "-N", "deploy", "-h", iprange_setting, "-t", enrollment_token])
runway_proc.wait()
    

    
