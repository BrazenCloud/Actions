import psutil, socket

from baseAction import base_action

#
# Create an action class inheriting from the base_action class
#
class kill_running_process(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    # Any action specific variables should be defined here.
    #
    def __init__(self):
        super(kill_running_process, self).__init__()
        self.kill_by = self.get_setting("Kill By (PPID, Name)")
        self.kill_key = self.get_setting("PPID or Name")

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Kill Running Process"
        self.response.type = "KillRunningProcess"
        # ppid is parent process ID
        # exe is the running application.  Is this what is meant by 'file path'?
        # name is the process name
        # username is the owner of a process 
        # what is meant by md5?
        try:
            # create list of data that will be added to the json results
            killed_processes = list()
            for proc in psutil.process_iter():
                c_key = ""
                if "PPID" == self.kill_by:
                    proc_key = str(proc.ppid())
                elif "Name" == self.kill_by:
                    proc_key = proc.name()
                else:
                    self.response.status = "Error"
                    self.response.message = "Invalid Input, only PPID and Name are supported for Kill By"
                    break
                if proc_key.lower() == self.kill_key.lower():
                    # create dictionary that contains key/value pairs to be added to json result
                    d = {}
                    d["pid"] = proc.pid
                    d["name"] = proc.name()
                    killed_processes.append(d)
                    proc.kill()
            self.response.status = "Successful"
            # set results to the dictionary
            self.response.results = {"killed_processes": killed_processes}
            self.success = True

            if self.success == True:
                if len(self.response.results["killed_processes"]) > 1:
                    self.response.message = "Killed " + len(self.response.results["killed_processes"]) + " processes on " + socket.gethostname()
                elif len(self.response.results["killed_processes"]) > 0:
                    self.response.message = "Killed 1 process on " + socket.gethostname()
                else:
                    self.response.message = "No process with matching criteria to kill on " + socket.gethostname()
        except Exception as e:
            # set response if an exception is encountered
            self.response.status = "Error"
            self.response.message = str(e)
        self.output_results()

# create an instance of the specific action
action = kill_running_process()
# call the perform_action of the specific action
action.perform_action()
