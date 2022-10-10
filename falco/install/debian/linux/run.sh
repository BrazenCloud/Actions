# https://falco.org/docs/getting-started/installation/#debian
# Trust the falcosecurity GPG key, configure the apt repository, and update the package list:
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y

# Install kernel headers:
apt-get -y install linux-headers-$(uname -r)

# Install Falco:
apt-get install -y falco

# install driver
falco-driver-loader

# start service
systemctl enable falco
systemctl start falco