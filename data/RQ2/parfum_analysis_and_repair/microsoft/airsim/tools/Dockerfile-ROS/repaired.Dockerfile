FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    apt-transport-https \
    software-properties-common \
    sudo \
    tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* && \
    dpkg-reconfigure -f noninteractive tzdata

ARG UNAME=testuser

# Create new user `docker` and disable password and gecos for later
RUN adduser --disabled-password --gecos '' $UNAME
# Add new user docker to sudo group
RUN adduser $UNAME sudo

# Ensure sudo group users are not
# asked for a password when using
# sudo command by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD install_ros_deps.sh /
RUN chmod +x /install_ros_deps.sh
RUN DEBIAN_FRONTEND=noninteractive /install_ros_deps.sh

USER $UNAME
WORKDIR /home/${UNAME}
