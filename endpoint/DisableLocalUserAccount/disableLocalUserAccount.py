import json, os, socket, subprocess, sys

from baseAction import base_action

#
# Create an action class inheriting from the base_action class
#
class disable_local_user_account(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    # Any action specific variables should be defined here.
    #
    def __init__(self):
        super(disable_local_user_account, self).__init__()
        self.userid = self.get_setting("User ID")

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Disable Local User Account"
        self.response.type = "DisableLocalUserAccount"
        user_disabled = False
        try:
            if os.name == 'posix':
                # execute a process on the host, pipe the process stdout and stderr
                command = "usermod -L " + self.userid
                out, err = subprocess.Popen(command, shell=True, stdout = subprocess.PIPE, stderr= subprocess.PIPE).communicate()
                user_disabled = True
            elif os.name == 'nt':
                # execute a process on the host, pipe the process stdout and stderr
                command = "net user " + self.userid + " /active:no"
                out, err = subprocess.Popen(command, shell=True, stdout = subprocess.PIPE, stderr= subprocess.PIPE).communicate()
                out, err = subprocess.Popen(["powershell",  "-file",  os.getcwd() + os.sep + "CheckUser.ps1"], stdout=subprocess.PIPE).communicate()
                json_out = json.loads(out)

                for user in json_out:
                    if self.userid == user["Name"]:
                        if user["Disabled"] == True:
                            # the user has successfully been disabled
                            user_disabled = True
                            
            # if there is nothing written to stderr, the command was successful
            if user_disabled == True:
                self.response.status = "Successful"
                self.response.message = "Disabled local user account for user: " + self.userid
                self.success = True
            else:
                self.response.status = "Error"
                self.response.message = "Error while disabling user " + self.userid + " - " + str(err)
        except Exception as e:
            # set response if an exception is encountered
            self.response.status = "Error"
            self.response.message = str(e)
        self.output_results()

# create an instance of the specific action
action = disable_local_user_account()
# call the perform_action of the specific action
action.perform_action()
