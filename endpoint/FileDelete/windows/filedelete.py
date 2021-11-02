import os
import json

print("python script has started.")

#
# you can modify this class to store whatever data you want in the final json output
#
class CResponse:
    def __init__(self):
        self.status = 'uninitialized'
        self.message = 'Did not run'
        
settings_file = 0
settings = { }

#
# Load the user settings, if any.  These are supplied at action runtime.  
# This file is generated at runtime, do not pre-create this file.
#
if(os.path.exists("..\\settings.json")):
    print("../settings.json file found, loading settings...")
    settings_file = open("..\\settings.json", "r")
    settings = json.load(settings_file);
    settings_file.close()
else:
    print("../settings.json file not found, script may not be able to complete successfully...")
    
success = False    
filepath = ""
response = CResponse()

if(settings_file):
    if(settings.has_key("Filepath")):
        filepath = settings["Filepath"];

if len(filepath) > 0:
    try:
       os.remove(filepath)
       response.status = 'success'
       response.message = 'File deleted Successfully'
       success = True
    except Exception as e:
       response.status = str(e)
       response.message = 'Error deleting file'
else:
    print("filepath was not specified, no file will be deleted.")
       
#
# output the results as json
#   
print("the results of the script, in json:")
print("-----------------------------------")    
json_output = json.dumps(response, default=lambda x: x.__dict__)
print(json_output)
print("-----------------------------------")

if(os.path.exists("..\\results")):
    print("outputting result json file to ../results/output.json")
    f = open("..\\results\\output.json", "w+")
    f.write(json_output)
    f.close()
else:
    print("../results directory not found, result json will not be saved")
    
if(success):    
    print("python script has completed successfully.")
else:
    print("python script has completed with errors.")
    
    
