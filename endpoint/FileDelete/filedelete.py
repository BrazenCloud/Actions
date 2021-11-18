import os

from baseAction import base_action

#
# Create an action class inheriting from the base_action class
#
class file_delete(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    # Any action specific variables should be defined here.
    #
    def __init__(self):
        super(file_delete, self).__init__()
        self.filepath = self.get_setting("Filepath")

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Delete File"
        self.response.type = "DeleteFile"
    
        #
        # This script takes a single string argument, filepath.
        # To control what arguments the script takes, edit the parameters.json 
        # file in the root of the action.
        #
        # Check to make sure the filepath setting has been made, it is required to delete a file.
        #
        if len(self.filepath) > 0:
            try:
                #
                # Edit the lines of code here to make this script do almost ANYTHING
                # TODO: add or modify code here
                #
                os.remove(self.filepath)
                response.status = "Success"
                response.message = "File " + self.filepath + " deleted Successfully"
                d = {}
                d["filepath"] = self.filepath
                self.response.results.append(d)
                success = True
            except Exception as e:
                response.status = "Error"
                response.message = str(e)
        else:
            response.status = "Error"
            response.message = "Unable to delete file,  no file was provided."
            print("filepath was not specified, no file will be deleted.")
        self.output_results()

# create an instance of the specific action
action = file_delete()
# call the perform_action of the specific action
action.perform_action()       