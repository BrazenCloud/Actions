import json, platform, subprocess

def is_grafana_installed():
    # execute a process on the host, pipe the process stdout
    proc = __run_proc__("curl -X GET 'http://localhost:3000'")
    out, err = proc.communicate()
    if len(out) > 0:
        return True
    else:
        return False

# test elastic
    # curl -X GET 'http://localhost:9200'
    """
        {
        "node.name" : "My First Node",
        "cluster.name" : "mycluster1",
        "version" : {
            "number" : "2.3.1",
            "build_hash" : "bd980929010aef404e7cb0843e61d0665269fc39",
            "build_timestamp" : "2020-04-04T12:25:05Z",
            "build_snapshot" : false,
            "lucene_version" : "5.5.0"
        },
        "tagline" : "You Know, for Search"
        }
    """
def install_grafana():
    if "Linux" == platform.system():
        # print(platform.linux_distribution())
        # only supporting Ubuntu
        if "Ubuntu" == platform.linux_distribution()[0]:
            return __install_grafana_ubuntu__()
    elif "Windows" == platform.system():
        return False
    else:
        print("OS not supported")
    return False

def uninstall_grafana():
    if "Linux" == platform.system():
        # only supporting Ubuntu
        if "Ubuntu" == platform.linux_distribution()[0]:
            return __uninstall_grafana_ubuntu__()
    elif "Windows" == platform.system():
        return False
    else:
        print("OS not supported")
    return False

def __run_proc__(command):
    # execute a process on the host, pipe the process stdout
    proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return proc

def __install_grafana_ubuntu__():
    print("Installing Grafana on Ubuntu")
    proc = __run_proc__("apt install -y apt-transport-https")
    out, err = proc.communicate()
    proc = __run_proc__("apt install -y software-properties-common wget")
    out, err = proc.communicate()
    proc = __run_proc__("wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -")
    out, err = proc.communicate()
    proc = __run_proc__('echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list')
    out, err = proc.communicate()
    proc = __run_proc__("apt update -y")
    out, err = proc.communicate()
    proc = __run_proc__("apt install -y grafana")
    out, err = proc.communicate()
    proc = __run_proc__("systemctl daemon-reload")
    out, err = proc.communicate()
    proc = __run_proc__("systemctl start grafana-server")
    out, err = proc.communicate()
    proc = __run_proc__("systemctl enable grafana-server")
    out, err = proc.communicate()
    installed = is_grafana_installed()
    return installed

# uninstall is not working
def __uninstall_grafana_ubuntu__():
    print("Uninstalling Grafana on Ubuntu")
    proc = __run_proc__("systemctl stop grafana-server")
    out, err = proc.communicate()
    proc = __run_proc__("apt remove --auto-remove grafana -y")
    out, err = proc.communicate()
    uninstalled = not is_grafana_installed()
    return uninstalled

# if is_grafana_installed():
#     uninstall_grafana()
# install_grafana()
