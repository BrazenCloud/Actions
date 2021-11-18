import json, os

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

    def __init__(self):
        #
        # initialize the variables   
        #
        self.settings = { }
        self.success = False    
        self.response = response_data()

        # load settings
        self.load_settings()

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
        if(os.path.exists(".." + os.sep + "settings.json")):
            settings_file = open(".." + os.sep + "settings.json", "r")
            self.settings = json.load(settings_file);
            settings_file.close()
        else:
            print(".." + os.sep + "settings.json file not found, script may not be able to complete successfully...")

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
    