From ubuntu:16.04

Run apt-get update && apt-get -y upgrade

Run apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

Cmd ["/sbin/init"]
#Entrypoint /opt/dfm/install_ubuntu.sh
