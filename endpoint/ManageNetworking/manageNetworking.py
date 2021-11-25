import json, os, socket, subprocess, sys

from baseAction import base_action

#
# Create an action class inheriting from the base_action class
#
class manage_networking(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    # Any action specific variables should be defined here.
    #
    def __init__(self):
        super(manage_networking, self).__init__()
        self.action = self.get_setting("Network Action (Block or Allow)")
        self.direction = self.get_setting("Direction (inbound/Outbound)")
        self.port = self.get_setting("Port")
        self.protocol = self.get_setting("Protocol (TCP or UDP)")
        self.addresses = self.get_setting("IP Address (comma seperated list)")
        if self.get_setting("Enable") == "false":
            self.enable = "Disable"
        else:
            self.enable = "Enable"

        if self.addresses is None or self.addresses == "":
            self.addresses = "All"

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Manage Networking"
        self.response.type = "ManageNetworking"

        try:
            if os.name == 'posix':
                pass
            elif os.name == 'nt':
                # execute a process on the host, pipe the process stdout and stderr
                out, err = subprocess.Popen(["powershell", "-ExecutionPolicy", "Bypass", "-file",  os.getcwd() + os.sep + "ManageNetworking.ps1",
                    "-Enable", self.enable, "-NetworkAction", self.action, "-Direction", self.direction, "-Port", self.port, 
                    "-Protocol", self.protocol, "-Address", self.addresses], stdout=subprocess.PIPE).communicate()

                json_out = json.loads(out)

                for key in json_out:
                    if key == "Successful":
                        if json_out[key] == True:
                            self.success = True
                            self.response.status = "Successful"
                    elif key == "Message":
                        self.response.message = json_out[key]

            if self.success == False:
                self.response.status = "Error"
        except Exception as e:
            # set response if an exception is encountered
            self.response.status = "Error"
            self.response.message = str(e)
        self.output_results()

# create an instance of the specific action
action = manage_networking()
# call the perform_action of the specific action
action.perform_action()
