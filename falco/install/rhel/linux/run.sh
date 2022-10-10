# Trust the falcosecurity GPG key and configure the yum repository:
rpm --import https://falco.org/repo/falcosecurity-3672BA8F.asc
curl -s -o /etc/yum.repos.d/falcosecurity.repo https://falco.org/repo/falcosecurity-rpm.repo

# Note — The following command is required only if DKMS and make are not available in the distribution. You can verify if DKMS is available using yum list make dkms. If necessary install it using: yum install epel-release (or amazon-linux-extras install epel in case of amzn2), then yum install make dkms.

# Install kernel headers:
yum -y install kernel-devel-$(uname -r)

# Note — If the package was not found by the above command, you might need to run yum distro-sync in order to fix it. Rebooting the system may be required.

# Install Falco:
yum -y install falco

# install driver
falco-driver-loader

# start service
systemctl enable falco
systemctl start falco