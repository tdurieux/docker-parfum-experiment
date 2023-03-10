#
# Dockerfile for building APISERVER
#

# Build the APISERVER using phusion base image

FROM phusion/baseimage:master-amd64

# Enabling SSH service
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Installing nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;

# Copying public keys to get SSH access to this Container
COPY *.pub /tmp/
RUN cat /tmp/*.pub >> /root/.ssh/authorized_keys && rm -f /tmp/*.pub

# Copying the version-source
ADD version.tar.gz /opt/
COPY version_start /etc/service/version_start/run
RUN chmod +x /etc/service/version_start/run

# Copying the DNC-Server source
ADD dncserver/ /apiserver/dncserver/

# Copying the DNC-Std-Plugin source
ADD dncstdplugin/ /apiserver/dncstdplugin/

# Copying the DNC-Grafana-Influx-Plugin source
ADD dncgiplugin/ /apiserver/dncgiplugin/

# To start DNC-SERVER during system boot
COPY dncserver_start /etc/service/dncserver_start/run
RUN chmod +x /etc/service/dncserver_start/run

# TO start DNC-STANDARD-PLUGIN during system boot
COPY dncstdplugin_start /etc/service/dncstdplugin_start/run
RUN chmod +x /etc/service/dncstdplugin_start/run

# TO start DNC-GRAFANA-INFLUXDB-PLUGIN during system boot
COPY dncgiplugin_start /etc/service/dncgiplugin_start/run
RUN chmod +x /etc/service/dncgiplugin_start/run
