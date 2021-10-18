import os
import sys
import ctypes
import json
import zipfile
import re

# if you intend on connecting to a restful api
#import urllib2
#import ssl

#
# data formatting
#
#import csv
#import mariadb

# anything you print will be logged in the runway console, which helps debugging
print("Loading example.py script...\n")

# ----------------------------------------------------
# this block of code is largely cut-and-pasteable
# should probably put this into a helper .py class
#
# download the job results to a directory and unzip it
# ----------------------------------------------------
print("Loading runway library...\n")

#
# if you use 64 bit python, use the 64 bit runway DLL
# if you use 32 bit python, use the 32 bit runway DLL
#
runway = ctypes.CDLL("..\\runway64.dll")

if not runway:
    print("Error, could not load runway DLL\n")
    exit(-1)
    
# apparently you need to tell ctypes that these are char *
runway.ThreadId.restype = ctypes.c_char_p
runway.ProdigalEndpointName.restype = ctypes.c_char_p
runway.DownloadResult.argypes = [ctypes.c_char_p];

#
# uncomment this SetSimulation() line if you want to simulate running as an applet
# in this mode:
#   endpoint_name = 'test_endpoint'
#   thread_id = 'test_threadid'
# and DownloadResults will always return 0 (success) but not actually do anything
#
# for testing just manually copy the zip file to the appropriate location as if it were already downloaded
#
# runway.SetSimulation()

# use the worker thread id and the endpoint name to create the filename
# the thread id is unique to this specific job-->endpoint instance of work
threadid = runway.ThreadId().decode()
if(0 == len(threadid)):
    print("Error, could not get thread id\n")
    sys.exit(-1)  

print("Got thread id " + threadid + "\n")

# this is the endpoint name from which the results were obtained
endpointname = runway.ProdigalEndpointName(threadid).decode()
if(0 == len(endpointname)):
    print("Error, could not get endpoint name\n")
    sys.exit(-1)
        
print("Got endpoint name " + endpointname + "\n")

endpointname = endpointname.replace(' ', '_')
package_name = endpointname + "_" + threadid + ".zip"
package_zipdir = endpointname + "_" + threadid

full_path = ""

#
# you really could store this anywhere.  
# when applets run, they are stored under the runway agent thus:
# agent_dir_guid/work_tree/[thread_id_guid]/[applet_id_guid]/<applet is unzipped here>
# so, by using ../../../../download, the downloaded results end up thus:
# agent_dir_guid/download/<your download here>.zip
#
# this location seems easy to access from the file browser and keeps you out of all
# those ugly guid directories
#
if(False == os.path.isdir("..\\..\\..\\..\\download\\")):
    os.mkdir("..\\..\\..\\..\\download\\")
full_path = "..\\..\\..\\..\\download\\" + package_name
full_zipdir = "..\\..\\..\\..\\download\\" + package_zipdir

print("Downloading job result for endpoint " + endpointname + " to '" + package_name + "'\n")

if runway.DownloadResult(full_path.encode('utf8')) == 0:
    print("Download was successful.\n")
    with zipfile.ZipFile(full_path, 'r') as zip_ref:
        zip_ref.extractall(full_zipdir)
else:
    print("Downloading job result failed\n")
    exit(-1)
    
print("Results unzipped to: " + full_path + "\n")

# ----------------------------------------------------
# download and unzip finished
# ----------------------------------------------------

#
# IF YOU HAVE SETTINGS
#
settings_file = open("..\\settings.json", "r")
settings = json.load(settings_file);
some_setting = settings["My Setting"];

print("My setting is " + some_setting + "\n")

# IF THIS IS A CONNECTION APPLET 
# the connection information is up to you, this is configured under 'Connectors' in the runway GUI
# and exposed in the settings above
connection_string = settings["Connection String"];

print("Got connection string: " + connection_string + "\n")

r1 = "^([0-9\.A-Za-z_]+):([0-9]+):([A-Za-z_]+)$"
r1m = re.search(r1, connection_string)

connection_address = r1m.group(1)
connection_port = r1m.group(2)
connection_database = r1m.group(3)

print("using connection to address " + connection_address + ":" + connection_port + " and database name " + connection_database + "\n")
