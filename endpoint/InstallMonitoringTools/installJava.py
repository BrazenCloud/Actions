import platform, subprocess

def is_java_installed():
    # execute a process on the host, pipe the process stdout
    proc = __run_proc__("java -version")
    # get the piped stdout
    out, err = proc.communicate()
    if "not found" in err:
        return False
    else:
        return True

def install_java():
    if "Linux" == platform.system():
        # print(platform.linux_distribution())
        # only supporting Ubuntu
        if "Ubuntu" == platform.linux_distribution()[0]:
            return __install_java_ubuntu__()
    elif "Windows" == platform.system():
        return False
    else:
        print("OS not supported")
    return False

def uninstall_java():
    if "Linux" == platform.system():
        # only supporting Ubuntu
        if "Ubuntu" == platform.linux_distribution()[0]:
            return __uninstall_java_ubuntu__()
    elif "Windows" == platform.system():
        return False
    else:
        print("OS not supported")
    return False

def __run_proc__(command):
    # execute a process on the host, pipe the process stdout
    proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return proc

""""
    Install Java, return true if successful, otherwise return false
"""
def __install_java_ubuntu__():
    print("Installing Java on Ubuntu")
    proc = __run_proc__("apt update -y")
    out, err = proc.communicate()
    proc = __run_proc__("apt install default-jre -y")
    out, err = proc.communicate()
    installed = is_java_installed()
    return installed

# return true if Java was uninstalled
def __uninstall_java_ubuntu__():
    print("Uninstalling Java on Ubuntu")
    proc = __run_proc__("apt purge openjdk* -y")
    out, err = proc.communicate()
    uninstalled = not is_java_installed()
    return uninstalled

# if not is_java_installed():
#     install_java()
# else:
#     uninstall_java()
