import os, socket, sys

if os.name == 'posix':
    sys.path.append(sys.path[0] + os.sep + "linux")
    sys.path.append(sys.path[0] + os.sep + "linux/psutil")
elif os.name == 'nt':
    sys.path.append(sys.path[0] + os.sep + "windows")
    sys.path.append(sys.path[0] + os.sep + "windows/psutil")

import psutil

from baseAction import base_action

#
# Create an action class inheriting from the base_action class
#
class get_running_processes(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    def __init__(self):
        super(get_running_processes, self).__init__()

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Run Get Running Processes"
        self.response.type = "GetRunningProcesses"
        try:
            # Iterate over all running process
            for proc in psutil.process_iter():
                try:
                    d = {}
                    self.response.results.append(d)
                    # pInfoDict = proc.as_dict()
                    pInfoDict = proc.as_dict(attrs=['pid', 'name', 'username', 'cpu_percent', 'create_time', 'exe'])
                    for proc_attr in pInfoDict:
                        d[proc_attr] = pInfoDict[proc_attr]
                except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
                    pass

            self.response.message = "Created list of running processes on " + socket.gethostname()
            self.response.status = "Successful"
            self.success = True
        except Exception as e:
            # set response if an exception is encountered
            self.response.status = str(e)
            self.response.message = "Error running Get Running Processes"
        self.output_results()

# create an instance of the specific action
action = get_running_processes()
# call the perform_action of the specific action
action.perform_action()
