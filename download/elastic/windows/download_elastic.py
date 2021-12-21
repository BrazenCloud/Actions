import os
import sys
import uuid
import json
import urllib2
import ssl
import zipfile
import subprocess
import glob
import shutil

connection_settings_file = open("..\\settings.json", "r")
connection_settings = json.load(connection_settings_file);
connection_address = connection_settings["URL"]

print("using elastic server at address " + connection_address + "\n")

settings_file = open("..\\settings.json", "r")
settings = json.load(settings_file);

host = "";
 
if(settings.has_key("host")):
    host = settings["host"];
    
if(0 == len(host)):
    print("Error, could not get server host name\n")
    sys.exit(-1)

# should put the data at ..\\download by default
runway_proc = subprocess.Popen(["runway.exe", "-N", "-S", host, "download"])
runway_proc.wait() 

all_zip_files = glob.glob("..\\download\\*.zip");

for zip_file in all_zip_files:
    print("detected zip file at " + zip_file)
    input_zipfile = "..\\download\\" + zip_file
    out_zipdir = "..\\download\\unzipped"
    with zipfile.ZipFile(input_zipfile, 'r') as zip_ref:
            zip_ref.extractall(out_zipdir)
    all_json_files = glob.glob("..\\download\\unzipped\\*.json");
    for json_file in all_json_files:
        print("detected json file at " + json_file)
        f = open(json_file,"r")
        json_data = f.read()
        request = urllib2.Request(connection_address)
        request.add_header('Content-Type', 'application/json')
        # we aren't using an ID so we need POST
        #request.get_method = lambda: 'PUT'
        # WARNING - this disables the SSL cert check - use for DEBUGGING ONLY
        context = ssl._create_unverified_context()
        print("Sending json file to elasticsearch server at URL " + connection_address)
        response = urllib2.urlopen(request, data=json_data, context=context)
    #shutil.rmtree("..\\download\\unzipped")
