import hashlib, os, socket, subprocess, sys

from baseAction import base_action

# Define constants for the parameters
PACKAGE = "Package"
PACKAGE_URL = "Package Download URL"
SHA_TYPE = "SHA Type (SHA1, SHA256 or SHA512)"
SHA_VALUE = "SHA Value"

#
# Create an action class inheriting from the base_action class
#
class install_package(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    # Any action specific variables should be defined here.
    #
    def __init__(self):
        super(install_package, self).__init__([PACKAGE, PACKAGE_URL, SHA_TYPE, SHA_VALUE])
        # self.package = self.get_setting("Package")
        # self.package_url = self.get_setting("Package Download URL")
        # self.sha_type = self.get_setting("SHA Type (SHA1, SHA256 or SHA512)")
        # self.sha_value = self.get_setting("SHA Value")
        # self.package_url = "https://dl.influxdata.com/influxdb/releases/influxdb_1.8.10_amd64.deb"
        # self.sha_value = "b2ace09231575df7309a41cea6f9dc7ad716fe4389dc06ac04470a14bd411456"
        # self.package = "influxdb"
        # self.sha_type = "SHA256"

    def __package_exists__(self):
            out, err = subprocess.Popen("dpkg -s " + self.params[PACKAGE], shell=True, stdout = subprocess.PIPE, stderr= subprocess.PIPE).communicate()
            return "Package: " + self.params[PACKAGE] in out

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Install Package"
        self.response.type = "InstallPackage"

        # validate parameter count
        # TODO what to do for handling optional parameters?
        if self.param_count != len(self.params):
            self.response.status = "Error"
            self.response.message = "Invalid Action, missing required parameters: " + self.find_missing_params()
        else:
            self.__internal_perform_action__()

        self.output_results()

    def __internal_perform_action__(self):
        try:
            split_url = self.params[PACKAGE_URL].split("/")
            downloaded_file = split_url[len(split_url) - 1]

            # if the file to download exists, first delete the file
            if os.path.exists(downloaded_file):
                print(downloaded_file + " exists already, it will be deleted.")
                os.remove(downloaded_file)
                print("Deleted existing file: " + downloaded_file)

            # if package is installed, uninstall
            if self.__package_exists__():
                print("Package " + self.params[PACKAGE] + " exists, it will be uninstalled")
                out, err = subprocess.Popen("apt purge --auto-remove -y " + self.params[PACKAGE], shell=True, stdout = subprocess.PIPE, stderr= subprocess.PIPE).communicate()
                print("Uninstalled package " + self.params[PACKAGE])

            # execute a process on the host, pipe the process stdout
            # download the package file
            print("Downloading file " + downloaded_file + " from " + self.params[PACKAGE_URL])
            out, err = subprocess.Popen("wget " + self.params[PACKAGE_URL], shell=True, stdout = subprocess.PIPE, stderr= subprocess.PIPE).communicate()

            # Verify the file was downloaded
            if os.path.exists(downloaded_file):
                print("Downloaded file " + downloaded_file)
                # verify the download by the SHA
                BUF_SIZE = 262144  # read in 256kb chunks

                if "SHA256" == self.params[SHA_TYPE]:
                    sha = hashlib.sha256()
                elif "SHA1" == self.params[SHA_TYPE]:
                    sha = hashlib.sha1()
                elif "SHA512" == self.params[SHA_TYPE]:
                    sha = hashlib.sha512()

                with open(downloaded_file, 'rb') as f:
                    while True:
                        data = f.read(BUF_SIZE)
                        if not data:
                            break
                        sha.update(data)
                sha_val = sha.hexdigest()

                # verify the downloaded files SHA
                print("Verifying " + self.params[SHA_TYPE] + " for file " + downloaded_file)
                if sha_val == self.params[SHA_VALUE]:
                    print("Verified " + self.params[SHA_TYPE] + " for file " + downloaded_file)
                    print("Installing package " + self.params[PACKAGE])
                    # if verified, install
                    out, err = subprocess.Popen("dpkg -i " + downloaded_file, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
                    if self.__package_exists__():
                        self.response.status = "Successful"
                        self.response.message = "Installed package " + self.params[PACKAGE] + " from: " + self.params[PACKAGE_URL]
                        # add the package name to the result that will be output to json
                        d = {}
                        self.response.results.append(d)
                        d["package"] = self.params[PACKAGE]
                        self.success = True
                        print("Installed package " + self.params[PACKAGE])
                    else:
                        self.response.status = "Error"
                        self.response.message = "Unsuccessful installation of package " + self.params[PACKAGE]
                        print("Package " + self.params[PACKAGE] + " successfully installed")
                else:
                    print("Unable to verify " + self.params[SHA_TYPE] + " for file " + downloaded_file)
                    self.response.status = "Error"
                    self.response.message = "Unable to install package from : " + self.params[PACKAGE_URL] + ", the SHA does not match"
            else:
                print("Unable to download file from " + self.params[PACKAGE_URL])
                self.response.status = "Error"
                self.response.message = "Unable to install package from : " + self.params[PACKAGE_URL] + ", the file was not downloaded successfully"
        except Exception as e:
            # set response if an exception is encountered
            self.response.status = "Error"
            self.response.message = str(e)

        # perform cleanup by deleting the downloaded file
        if os.path.exists(downloaded_file):
            print("Deleting downloaded file: " + downloaded_file)
            os.remove(downloaded_file)

# create an instance of the specific action
action = install_package()
# call the perform_action of the specific action
action.perform_action()
