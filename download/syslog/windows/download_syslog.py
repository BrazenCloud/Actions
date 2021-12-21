import os
import sys
#import uuid
import ctypes
import json
#import urllib2
#import ssl
import zipfile
import logging
import logging.handlers
import shutil

connection_settings_file = open("..\\settings.json", "r")
connection_settings = json.load(connection_settings_file);
connection_address = connection_settings["URL"]

print("using syslog server at address " + connection_address + "\n")

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

#
# get syslog client up
#
logger = logging.getLogger()
logger.setLevel(logging.INFO)
syslog_handler = logging.handlers.SysLogHandler(address=(connection_address, 514))
logger.addHandler(syslog_handler)

for zip_file in all_zip_files:
    print("detected zip file at " + zip_file)
    input_zipfile = "..\\download\\" + zip_file
    out_zipdir = "..\\download\\unzipped"
    with zipfile.ZipFile(input_zipfile, 'r') as zip_ref:
            zip_ref.extractall(out_zipdir)
    all_log_files = glob.glob("..\\download\\unzipped\\*.log");
    for log_file in all_log_files:
        print("detected log file at " + log_file)
        #
        # this expects a log file not a json object
        #
        results_file = full_zipdir + "\\results.log"
        with open(results_file) as f:
            line = f.readline()
            while line:
                logger.info(line.strip())
                line = f.readline()
        #
        # done
        #
    shutil.rmtree("..\\download\\unzipped")
 print("Done.")
