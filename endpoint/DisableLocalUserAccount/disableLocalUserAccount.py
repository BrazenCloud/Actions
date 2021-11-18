import socket, subprocess

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
        try:
            # execute a process on the host, pipe the process stdout and stderr
            proc = subprocess.Popen(['usermod', '-L', self.userid], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            # get the piped stdout
            out, err = proc.communicate()

            # if there is nothing written to stderr, the command was successful
            if err == "":
                self.response.status = "Successful"
                self.response.message = "Disabled local user account for user: " + self.userid
                self.success = True
            else:
                self.response.status = "Error"
                self.response.message = str(err)
        except Exception as e:
            # set response if an exception is encountered
            self.response.status = "Error"
            self.response.message = str(e)
        self.output_results()

# create an instance of the specific action
action = disable_local_user_account()
# call the perform_action of the specific action
action.perform_action()
