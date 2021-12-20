import json, socket

from baseAction import base_action

# osquery must be in the system path
#
# Create an action class inheriting from the base_action class
#
class run_os_query(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    def __init__(self):
        super(run_os_query, self).__init__()
        self.query = self.get_setting("Query")

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Run OSQuery"
        self.type = "RunOSQuery"
        try:
            # execute a process on the host, pipe the process stdout
            proc = subprocess.Popen(['osqueryi', '--json', self.query], stdout=subprocess.PIPE)
            # get the piped stdout
            stdout_value = proc.communicate()[0]
            # parse the process output and populate the response
            json_out = json.loads(stdout_value)
            for r in json_out:
                d = {}
                self.response.results.append(d)
                for key in r:
                    d[key] = r[key]

            self.response.message = "Ran Query on " + socket.gethostname() + ": " + self.query
            self.response.status = "Success"
            self.success = True
        except Exception as e:
            # set response if an exception is encountered
            self.response.status = str(e)
            self.response.message = "Error running OSQuery"
        self.output_results()

# create an instance of the specific action
action = run_os_query()
# call the perform_action of the specific action
action.perform_action()
