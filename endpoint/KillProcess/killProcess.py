import hashlib, os, socket, sys

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
        self.kill_by = self.get_setting("Kill By (PPID, Name, File Path, MD5)")
        self.kill_key = self.get_setting("Process")

    def __generate_md5_hash__(self, exe):
        md5_hash = None
        # Verify the file was downloaded
        if os.path.exists(exe):
            BUF_SIZE = 262144  # read in 256kb chunks

            md5 = hashlib.md5()
            with open(exe, 'rb') as f:
                while True:
                    data = f.read(BUF_SIZE)
                    if not data:
                        break
                    md5.update(data)
            md5_hash = md5.hexdigest()
        return md5_hash

    def __get_proc_key__(self, proc):
        proc_key = None
        try:
            if "PPID" == self.kill_by:
                proc_key = str(proc.ppid())
            elif "Name" == self.kill_by:
                proc_key = proc.name()
            elif "File Path" == self.kill_by:
                proc_key = proc.exe()
            elif "MD5" == self.kill_by:
                proc_key = self.__generate_md5_hash__(proc.exe())
        except (psutil.AccessDenied):
            print("Unable to access the process information [AccessDenied], skipping process")

        return proc_key
    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Kill Running Process"
        self.response.type = "KillRunningProcess"
        # ppid is parent process ID
        # exe is the running application (file path)
        # name is the process name
        # md5 is the has of the file
        try:
            # create list of data that will be added to the json results
            killed_processes = list()

            for proc in psutil.process_iter():
                proc_key = self.__get_proc_key__(proc)
                if proc_key is None:
                    continue
                if proc_key == self.kill_key:
                    # create dictionary that contains key/value pairs to be added to json result
                    d = {}
                    d["pid"] = proc.pid
                    d["name"] = proc.name()
                    killed_processes.append(d)
                    proc.kill()
                    print("Process " + proc_key + " killed")

            if len(killed_processes) > 0:
                self.response.status = "Successful"
                # set results to the dictionary
                self.response.results = {"killed_processes": killed_processes}
                self.success = True
                self.response.message = "Killed " + str(len(killed_processes)) + " processes on " + socket.gethostname()
            elif len(killed_processes) == 1:
                self.response.message = "Killed 1 process on " + socket.gethostname()
            else:
                self.response.status = "Error"
                self.response.message = "No process with matching criteria to kill on " + socket.gethostname()

        except Exception as e:
            # set response if an exception is encountered
            print("Exception while killing process")
            self.response.status = "Error"
            self.response.message = str(e)
        self.output_results()

# create an instance of the specific action
action = kill_running_process()
# call the perform_action of the specific action
action.perform_action()
