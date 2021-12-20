import json, os, sys

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
class get_free_disk_space(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    # Any action specific variables should be defined here.
    #
    def __init__(self):
        super(get_free_disk_space, self).__init__()
        self.filepath = self.get_setting("Filepath")

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Get Free Disk Space"
        self.response.type = "GetFreeDiskSpace"
        try:
            # get the free disk space
            free_space = psutil.disk_usage(".").free

            # set the response fields
            self.response.status = "Success"
            self.response.message = "There are " + str(free_space) + " bytes of free space available"
            d = {}
            d["free_space"] = free_space
            self.response.results.append(d)
            self.success = True
        except Exception as e:
            # set response if an exception is encountered
            self.response.status = "Error"
            self.response.message = str(e)
        self.output_results()

# create an instance of the specific action
action = get_free_disk_space()
# call the perform_action of the specific action
action.perform_action()