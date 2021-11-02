import platform
import subprocess
import json
import re

print("python script has started.")

class CProcess:
    def __init__(self):
        self.handles = ''
        self.name = ''
        self.priority = ''
        self.pid = ''
        self.threads = ''
        self.workingset = ''
        
class CResponse:
    def __init__(self):
        self.status = 'uninitialized'
        self.message = 'Did not run'
        self.processes = []

success = False 
response = CResponse()

if platform.system() == 'Windows':
    print("Detected windows platform")
    
    try:
        #
        # modify this regex to match the output of the cmdline you are calling below
        #
        regex = "([0-9]+)\s+(\S+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)"

        #
        # you can run ANY command here
        # of course, you need to modify the regex appropriately to extract data from the output
        #
        data = subprocess.check_output(['wmic', 'process', 'list', 'brief'])
        data = data.decode('utf-8')
        #print(data)
        
        #
        # split the output into individual lines
        #
        processes = data.splitlines()
        
        for line in processes:
            print(line)
            regex_match = re.search(regex, line)
            if(regex_match):
                print('regex match:' + ' handles: ' + regex_match.group(1) + ' name: '  + regex_match.group(2) + ' priority: ' + regex_match.group(3) + ' pid: ' + regex_match.group(4) + ' threads: ' + regex_match.group(5) + ' workingset: ' + regex_match.group(6))
                process = CProcess()
                process.handles = regex_match.group(1)
                process.name = regex_match.group(2)
                process.priority = regex_match.group(3)
                process.pid = regex_match.group(4)
                process.threads = regex_match.group(5)
                process.workingset = regex_match.group(6)
                
                response.processes.append(process)
            
        response.status = "success"
        response.message = 'Successfully read process list'
        success = True
        
    except Exception as e:
       response.status = str(e)
       response.message = 'Error getting process list'

else:
    print("Detected non-windows platform")
    
    #
    # TODO implement me for whatever linux systems I might be on
    # 
    
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
    

