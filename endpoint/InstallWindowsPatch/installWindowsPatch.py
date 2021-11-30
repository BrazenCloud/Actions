import json, os, socket, subprocess

from baseAction import base_action

#
# Create an action class inheriting from the base_action class
#
class install_windows_patch(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    # Any action specific variables should be defined here.
    #
    def __init__(self):
        super(install_windows_patch, self).__init__()
        self.patch_id = self.get_setting("Patch ID (KB)")
        reboot = self.get_setting("Reboot")
        if reboot is None or reboot == False:
            self.reboot = "False"
        else:
            self.reboot = "True"

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Install Windows Patch"
        self.response.type = "InstallWindowsPatch"

        try:
            # execute a process on the host, pipe the process stdout and stderr
            out, err = subprocess.Popen(["powershell", "-ExecutionPolicy", "Bypass", "-file",  os.getcwd() + os.sep + "InstallWindowsPatch.ps1", 
                "-Patch", self.patch_id, "-Reboot", self.reboot], stdout=subprocess.PIPE).communicate()
            
            # suggest powershell script outputs to standard out only json containing results
            # the json can be handled here by looping over the json result
            json_out = json.loads(out)

            for output in json_out:
                print(output + ": " + str(json_out[output]))
                if "Successful"  == output:
                    self.success = json_out["Successful"]
                elif "Message" == output:
                    self.response.message = json_out["Message"]
                else:
                    d = {}
                    d[key] = json_out[key]
                    self.response.results.append(d)
            if self.success == True:
                self.response.status = "Successful"
            else:
                self.response.status = "Error"

        except Exception as e:
            # set response if an exception is encountered
            self.response.status = "Error"
            self.response.message = str(e)
        self.output_results()

# create an instance of the specific action
action = install_windows_patch()
# call the perform_action of the specific action
action.perform_action()
