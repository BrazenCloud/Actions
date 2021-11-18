import os, platform, socket

from baseAction import base_action

#
# Create an action class inheriting from the base_action class
#
class get_os_version(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    # Any action specific variables should be defined here.
    #
    def __init__(self):
        super(get_os_version, self).__init__()

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Get OS Version"
        self.response.type = "GetOSVersion"
        try:
            d = {}
            d["name"] = platform.system()
            d["platform"] = platform.platform()
            d["version"] = platform.release()
            self.response.results.append(d)
            self.response.status = "Successful"
            self.response.message = "Collected OS Version data"
            self.success = True
        except Exception as e:
            # set response if an exception is encountered
            self.response.status = "Error"
            self.response.message = str(e)
        self.output_results()

# create an instance of the specific action
action = get_os_version()
# call the perform_action of the specific action
action.perform_action()
