#
# Dockerfile for building EXPO
#

# Build the EXPO using phusion base image

FROM phusion/baseimage:master-amd64

# Enabling SSH service
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Installing the required Packages
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install --no-install-recommends nodejs tmux -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:git-core/ppa
RUN apt-get update && apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN npm install expo-cli --global && npm cache clean --force;

# Copying public keys to get SSH access to this Container
COPY *.pub /tmp/
RUN cat /tmp/*.pub >> /root/.ssh/authorized_keys && rm -f /tmp/*.pub

# Copying DNC-UI source
ADD dncui/ /expo/dncui/

# Starting Expo Service
COPY expo_start /etc/service/expo_start/run
RUN chmod +x /etc/service/expo_start/run
