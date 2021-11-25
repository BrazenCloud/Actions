import json, os, socket, subprocess

from baseAction import base_action

#
# Create an action class inheriting from the base_action class
#
class delete_registry_key(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    # Any action specific variables should be defined here.
    #
    def __init__(self):
        super(delete_registry_key, self).__init__()
        self.registry_path = self.get_setting("Registry Path")
        self.name = self.get_setting("Name")

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Delete Registry Key"
        self.response.type = "DeleteRegistryKey"

        try:
            # execute a process on the host, pipe the process stdout and stderr
            out, err = subprocess.Popen(["powershell",  "-file",  os.getcwd() + os.sep + "DeleteRegistryKey.ps1", 
                "-RegistryPath", self.registry_path, "-Name", self.name], stdout=subprocess.PIPE).communicate()
            
            # suggest powershell script outputs to standard out only json containing results
            # the json can be handled here by looping over the json result
            json_out = json.loads(out)

            for output in json_out:
                print(output + ": " + str(json_out[output]))
                if "Successful"  == output:
                    self.success = json_out["Successful"]
                elif "Message" == output:
                    self.response.message = json_out["Message"]
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
action = delete_registry_key()
# call the perform_action of the specific action
action.perform_action()
