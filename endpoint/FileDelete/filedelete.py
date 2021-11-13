import json, os

#
# Modify this class to store data to output in the json result.
#
class CResponse:
    def __init__(self):
        self.status = 'uninitialized'
        self.message = 'Did not run'

#
# initialize the settings and other variables   
#
settings_file = 0
settings = { }
success = False    
filepath = ""
response = CResponse()

#
# Load the user settings file, if any, into a dictionary. 
# The settings file is generated at Action runtime based on Action parameters.
# DO NOT CREATE THIS FILE!!!
#
if(os.path.exists(".." + os.sep + "settings.json")):
    settings_file = open(".." + os.sep + "settings.json", "r")
    settings = json.load(settings_file);
    settings_file.close()
else:
    print(".." + os.sep + "settings.json file not found, script may not be able to complete successfully...")
    
#
# Get the individual settings from the settings dictionary.
#
if(settings.has_key("Filepath")):
    filepath = settings["Filepath"];

#
# This script takes a single string argument, filepath.
# To control what arguments the script takes, edit the parameters.json 
# file in the root of the action.
#
# Check to make sure the filepath setting has been made, it is required to delete a file.
#
if len(filepath) > 0:
    try:
       #
       # Edit the lines of code here to make this script do almost ANYTHING
       # TODO: add or modify code here
       #
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

#
# Write the results to the output json file.
#
if(os.path.exists(".." + os.sep + "results")):
    print("outputting result json file to .." + os.sep + "results" + os.sep + "output.json")
    f = open(".." + os.sep + "results" + os.sep + "output.json", "w+")
    f.write(json_output)
    f.close()
else:
    print(".." + os.sep + "results directory not found, result json will not be saved")
    
if(success):    
    print("python script has completed successfully.")
else:
    print("python script has completed with errors.")
    