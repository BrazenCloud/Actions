import os, subprocess
# import getpass

from baseAction import base_action

# required:  Setup ssh keys on the remote host
#   for root on the host running the Runway action
#       run ssh-keygen and accept all defaults, do not enter a passphrase 
#   ssh-keygen
#
#   for root on the host running the Runway action
#       run ssh-copy-id to the remote host for the upload/download
#   ssh-copy-id -i ~/.ssh/id_rsa.pub mnicosia99@83.136.219.114

# Define constants for the parameters
REMOTE_USER = "Remote User"
REMOTE_HOST = "Remote Host"
TARGET_FOLDER = "Target Folder"
SOURCE_FILE = "Source File"
SCP_TYPE = "SCP Type (Upload or Download)"

REQUIRED_PARAMS = [REMOTE_USER, REMOTE_HOST, TARGET_FOLDER, SOURCE_FILE, SCP_TYPE]
ALL_PARAMS = [REMOTE_USER, REMOTE_HOST, TARGET_FOLDER, SOURCE_FILE, SCP_TYPE]

#
# Create an action class inheriting from the base_action class
#
class remote_file_copy(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    # Any action specific variables should be defined here.
    #
    def __init__(self):
        super(remote_file_copy, self).__init__(ALL_PARAMS, REQUIRED_PARAMS)

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Remote File Copy"
        self.response.type = "RemoteFileCopy"
        missing_required_param = False
        input_valid = True
        invalid_input_message = list()

        # validate input
        # verify all required parameters are provided
        if len(self.find_missing_params()) > 0:
            missing_required_param = True
        # verify input parameters are valid
        if not missing_required_param:
            if self.params[SCP_TYPE] != "Upload" and self.params[SCP_TYPE] != "Download":
                invalid_input_message.append("SCP Type " + self.params[SCP_TYPE] + " is not valid.")
                input_valid = False
            if "Download" == self.params[SCP_TYPE]:
                if not os.path.isdir(self.params[TARGET_FOLDER]):
                    invalid_input_message.append("Target Folder " + self.params[TARGET_FOLDER] + " doesn't exist.")
                    input_valid = False
            elif "Upload" == self.params[SCP_TYPE]:
                if not os.path.exists(self.params[SOURCE_FILE]):
                    invalid_input_message.append("Source File " + self.params[SOURCE_FILE] + " doesn't exist.")
                    input_valid = False
        
        if not input_valid:
            self.response.status = "Error"
            self.response.message = "Invalid Action, invalid input parameters: " + str(invalid_input_message)
        elif missing_required_param:
            self.response.status = "Error"
            self.response.message = "Invalid Action, missing required parameters: " + str(self.find_missing_params())
        else:
            self.__internal_perform_action__()
        self.output_results()

    def __internal_perform_action__(self):
        try:
            if "Upload" == self.params[SCP_TYPE]:
                self.response.name = "File Upload"
                self.response.type = "FileUpload"
                id_file = "-i C:/ProgramData/ssh/ssh_host_rsa_key"
                command = "scp -o StrictHostKeyChecking=no " + id_file + " " + self.params[SOURCE_FILE] + " " + self.params[REMOTE_USER] + "@" + self.params[REMOTE_HOST] + ":" + self.params[TARGET_FOLDER]
                out, err = subprocess.Popen(command, shell=True, stdout = subprocess.PIPE, stderr= subprocess.PIPE).communicate()
                self.response.message = "File " + self.params[SOURCE_FILE] + " uploaded successfully to " + self.params[TARGET_FOLDER]
            elif "Download" == self.params[SCP_TYPE]:
                self.response.name = "File Download"
                self.response.type = "FileDownload"
                id_file = "-i C:/ProgramData/ssh/ssh_host_rsa_key"
                command = "scp -o StrictHostKeyChecking=no " + id_file + " " + self.params[REMOTE_USER] + "@" + self.params[REMOTE_HOST] + ":" + self.params[SOURCE_FILE] + " " + self.params[TARGET_FOLDER]
                out, err = subprocess.Popen(command, shell=True, stdout = subprocess.PIPE, stderr= subprocess.PIPE).communicate()
                self.response.message = "File " + self.params[SOURCE_FILE] + " downloaded successfully to " + self.params[TARGET_FOLDER]
            d = {}
            self.response.results.append(d)
            d["source_file"] = self.params[SOURCE_FILE]
            d["target_folder"] = self.params[TARGET_FOLDER]
            d["remote_host"] = self.params[REMOTE_HOST]
            self.response.status = "Successful"
            self.success = True
        except Exception as e:
            # set response if an exception is encountered
            self.response.status = "Error"
            self.response.message = str(e)

# create an instance of the specific action
action = remote_file_copy()
# call the perform_action of the specific action
action.perform_action()
