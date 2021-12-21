import os
import sys
import uuid
import json
import subprocess

#
# if the user made settings in the job editor, they will be in the following json file
#
settings_file = open("..\\settings.json", "r")
settings = json.load(settings_file);

host = "";

if(settings.has_key("host")):
    host = settings["host"];

if(0 == len(host)):
    print("Error, could not get server host name\n")
    sys.exit(-1)

use_path = "false"
path_setting = ""

if(settings.has_key("Use Path")):
    use_path = settings["Use Path"];

if(settings.has_key("Path")):
    path_setting = settings["Path"];

full_path = ""

if(use_path == "true" and path_setting):
    full_path = path_setting
else:
    if(False == os.path.isdir("..\\..\\..\\..\\download\\")):
        os.mkdir("..\\..\\..\\..\\download\\")
    full_path = "..\\..\\..\\..\\download\\"

print("Downloading job thread result to '" + full_path + "'\n")

runway_proc = subprocess.Popen(["runway.exe", "-N", "-S", host, "download", "--directory", full_path])
runway_proc.wait()


    
