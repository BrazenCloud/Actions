import json, os, sys

#
# This class stores data to output in the json result.
# Extend this class to add data to output in the json result.
#
class response_data(object):
    def __init__(self):
        self.name = 'uninitialized'
        self.type = 'uninitialized'
        self.status = 'uninitialized'
        self.message = 'Did not run'
        self.results = []

class base_action:

    def __init__(self, params=None):
        #
        # initialize the variables   
        #
        self.settings = { }
        self.success = False    
        self.response = response_data()
        self.param_count = 0
        self.params = {}
        self.param_keys = params

        # load settings
        self.load_settings()
        
        if params != None:
            self.param_count = len(params)
            # populate params
            for param in params:
                p = self.get_setting(param)
                if p != None and len(p) > 0:
                    self.params[param] = p

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
            self.response.message = "Invalid Request, missing required parameters: " + str(self.find_missing_params())
        else:
            self.__internal_perform_action__()

        self.output_results()

    def find_missing_params(self):
        missing_params = list()
        for param in self.param_keys:
            if not param in self.params:
                missing_params.append(param)
        return missing_params

    def load_settings(self):
        #
        # initialize the settings and other variables   
        #
        settings_file = 0
        self.settings = { }

        #
        # Load the user settings file, if any, into a dictionary. 
        # The settings file is generated at Action runtime based on Action parameters.
        # DO NOT CREATE THIS FILE!!!
        #
        print(os.getcwd())
        if(os.path.exists(".." + os.sep + "settings.json")):
            settings_file = open(".." + os.sep + "settings.json", "r")
            self.settings = json.load(settings_file);
            settings_file.close()
        else:
            print(".." + os.sep + "settings.json file not found, script may not be able to complete successfully...")

    def validate_params(self):
        return self.param_count == len(self.params)

    #
    # Get a setting from the settings dictionary, if the setting does not
    # exist, None is returned
    #
    def get_setting(self, setting):
        s = None
        if(self.settings.has_key(setting)):
            s = self.settings[setting];
        return s

    def output_results(self):       
        #
        # output the results as json
        #   
        print("the results of the script, in json:")
        print("-----------------------------------")    
        json_output = json.dumps(self.response, default=lambda x: x.__dict__)
        print(json_output)
        print("-----------------------------------")

        #
        # Write the results to the output json file.
        #
        if(os.path.exists(".." + os.sep + "results")):
            print("outputting result json file to .." + os.sep + "results" + os.sep + "output.json")
            f = open(".." + os.sep + "results" + os.sep + "output.json", "w+")
            f.write(json_output)
            f.close()
        else:
            print(".." + os.sep + "results directory not found, result json will not be saved")
            
        if(self.success):    
            print("python script has completed successfully.")
        else:
            print("python script has completed with errors.")
    