import os
import json

settings_file = 0
settings_file = open("../settings.json", "r")
settings = json.load(settings_file);
settings_file.close()

filepath = ""

class CResponse:
    def __init__(self):
        self.status = 'uninitialized'
        self.message = 'Did not run'
        
response = CResponse()

if(settings_file):
    if(settings.has_key("Filepath")):
        filepath = settings["Filepath"];

if len(filepath) > 0:
    try:
       os.remove(filepath)
       response.status = 'success'
       response.message = 'File deleted Successfully'
    except Exception as e:
       response.status = str(e)
       response.message = 'Error deleting file'
       
json_output = json.dumps(response, default=lambda x: x.__dict__)
print(json_output)

f = open("../results/output.json", "w+")
f.write(json_output)
f.close()