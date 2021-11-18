import json, platform, subprocess

def is_elastisearch_installed():
    # execute a process on the host, pipe the process stdout
    proc = __run_proc__("curl -X GET 'http://localhost:9200'")
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
def install_elastisearch():
    if "Linux" == platform.system():
        # print(platform.linux_distribution())
        # only supporting Ubuntu
        if "Ubuntu" == platform.linux_distribution()[0]:
            return __install_elastisearch_ubuntu__()
    elif "Windows" == platform.system():
        return False
    else:
        print("OS not supported")
    return False

def uninstall_elastisearch():
    if "Linux" == platform.system():
        # only supporting Ubuntu
        if "Ubuntu" == platform.linux_distribution()[0]:
            return __uninstall_elastisearch_ubuntu__()
    elif "Windows" == platform.system():
        return False
    else:
        print("OS not supported")
    return False

def __run_proc__(command):
    # execute a process on the host, pipe the process stdout
    proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return proc

def __install_elastisearch_ubuntu__():
    print("Installing Elastisearch on Ubuntu")
    proc = __run_proc__("curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -")
    out, err = proc.communicate()
    proc = __run_proc__('echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list')
    out, err = proc.communicate()
    proc = __run_proc__("apt update -y")
    out, err = proc.communicate()
    proc = __run_proc__("apt install elasticsearch -y")
    out, err = proc.communicate()
    proc = __run_proc__("sed -i -r 's/^#network.host: [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/network.host: localhost/g' /etc/elasticsearch/elasticsearch.yml")
    out, err = proc.communicate()
    proc = __run_proc__("systemctl start elasticsearch")
    out, err = proc.communicate()
    proc = __run_proc__("systemctl enable elasticsearch")
    out, err = proc.communicate()
    installed = is_elastisearch_installed()
    return installed

def __uninstall_elastisearch_ubuntu__():
    print("Uninstalling Elastisearch on Ubuntu")
    proc = __run_proc__("systemctl stop elasticsearch")
    out, err = proc.communicate()
    proc = __run_proc__("apt remove --auto-remove elasticsearch -y")
    out, err = proc.communicate()
    uninstalled = not is_elastisearch_installed()
    return uninstalled

# if is_elastisearch_installed():
#     uninstall_elastisearch()
# else:
#     install_elastisearch()
