import json, os, psutil

#
# Modify this class to store data to output in the json result.
#
class CResponse:
    def __init__(self):
        self.status = 'uninitialized'
        self.message = 'Did not run'

#
# initialize the variables   
#
success = False    
response = CResponse()

try:
    # get the free disk space
    free_space = psutil.disk_usage(".").free

    # set the response fields
    response.status = "success"
    response.message = "There are " + str(free_space) + " bytes of free space available"
    success = True

except Exception as e:
    # set response if an exception is encountered
    response.status = str(e)
    response.message = "Error getting free space"

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
