import json, os, socket

from baseAction import base_action

class hello_action(base_action, object):

    def __init__(self):
        super(hello_action, self).__init__()
        self.name = self.get_name()

    def get_name(self):
        name = "Unknown"
        if(self.settings.has_key("Name")):
            name = self.settings["Name"];
        return name
    
    def perform_action(self):
        try:
            self.response.name = self.name
            self.response.message = "Hello, " + self.name + " on " + socket.gethostname()
            self.response.status = "Success""
            self.success = True
        except Exception as e:
            # set response if an exception is encountered
            response.status = "Error""
            response.message = "Error - " + str(e)
        self.output_results()

action = hello_action()
action.perform_action()
