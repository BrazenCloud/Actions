import os

from installJava import install_java, is_java_installed, uninstall_java
from installElastisearch import is_elastisearch_installed, install_elastisearch, uninstall_elastisearch
from installGrafana import is_grafana_installed, install_grafana, uninstall_grafana

from baseAction import base_action

#
# Create an action class inheriting from the base_action class
#
class install_monitoring_tools(base_action, object):

    #
    # Initialize the action object and the base class of the action object
    # The base class of the action object contains the common functions for reading 
    # the settings file and writing the json results.
    #
    # Any action specific variables should be defined here.
    #
    def __init__(self):
        super(install_monitoring_tools, self).__init__()

    #
    # The perform_action is a specific action implementation, it should 
    # populate the response that will be written as json.
    #
    def perform_action(self):
        self.response.name = "Install Monitoring Tools"
        self.response.type = "InstallMonitoringTools"
        elastisearch_installed = False
        grafana_installed = False

        try:
            # if is_java_installed():
            #     uninstall_java()
            if is_elastisearch_installed():
                uninstall_elastisearch()
            if is_grafana_installed():
                uninstall_grafana()
            
            if not is_java_installed():
                print("Java not installed but required")
                install_java()

            if is_java_installed():
                install_elastisearch()
                elastisearch_installed = is_elastisearch_installed()
                d = {}
                d["elastisearch_installed"] = elastisearch_installed
                self.response.results.append(d)

            if elastisearch_installed:
                install_grafana()
                grafana_installed = is_grafana_installed()
                d = {}
                d["grafana_installed"] = grafana_installed
                self.response.results.append(d)

            if grafana_installed and elastisearch_installed:
                self.response.status = "Success"
                self.response.message = "Installed Grafana and Elastisearch Successfully"
                self.success = True
            else:
                self.response.status = "Error"
                self.response.message = "Unable to install Elastisearch and Grafana"

        except Exception as e:
            self.response.status = "Error"
            self.response.message = str(e)
        self.output_results()

# create an instance of the specific action
action = install_monitoring_tools()
# call the perform_action of the specific action
action.perform_action()       