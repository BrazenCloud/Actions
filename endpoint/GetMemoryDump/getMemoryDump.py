import json, os, socket, subprocess, sys

from baseAction import base_action

#
# Create an action class inheriting from the base_action class
#
class get_memory_dump(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    # Any action specific variables should be defined here.
    #
    def __init__(self):
        super(get_memory_dump, self).__init__()

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Get Memory Dump"
        self.response.type = "GetMemoryDump"

        try:
            if os.name == 'posix':
                # sudo bash ./linux/getProcessMemoryDump.sh self.pid
                out, err = subprocess.Popen(["bash",  os.getcwd() + os.sep + "getMemoryDump.sh"], 
                    stdout=subprocess.PIPE).communicate()
                if err is None or len(err) == 0:
                    self.response.message = out
                    self.success = True
                    self.response.status = "Successful"
                else:
                    self.response.message = out
                    self.response.status = "Error"
            elif os.name == 'nt':
                out, err = subprocess.Popen(["powershell", "-ExecutionPolicy", "Bypass", "-file",  os.getcwd() + os.sep + "GetMemoryDump.ps1", 
                stdout=subprocess.PIPE).communicate()

                json_out = json.loads(out)

                for key in json_out:
                    if key == "Successful":
                        if json_out[key] == True:
                            self.success = True
                            self.response.status = "Successful"
                    elif key == "Message":
                        self.response.message = json_out[key]
                    else:
                        d = {}
                        d[key] = json_out[key]
                        self.response.results.append(d)

            if self.success == False:
                self.response.status = "Error"
        except Exception as e:
            # set response if an exception is encountered
            self.response.status = "Error"
            self.response.message = str(e)
        self.output_results()

# create an instance of the specific action
action = get_memory_dump()
# call the perform_action of the specific action
action.perform_action()
