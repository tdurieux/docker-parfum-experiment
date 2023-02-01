#
# Create a master Labtainer image for use in running Labtainers from a container
# on any system that has Docker installed, withou having to install Labtainers.
# Thanks for Olivier Berger for this contribution.
#
#FROM ubuntu:xenial
FROM ubuntu:bionic

# Do not exclude man pages & other documentation
RUN rm /etc/dpkg/dpkg.cfg.d/excludes
# Reinstall all currently installed packages in order to get the man pages back
RUN apt-get update && \
    dpkg -l | grep ^ii | cut -d' ' -f3 | xargs apt-get install -y --reinstall && \
    rm -r /var/lib/apt/lists/*


LABEL description="This is Docker image for the Labtainers master controller, stage 1"
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    man \
    manpages \
    manpages-dev && rm -rf /var/lib/apt/lists/*;

#
ARG DOCKER_GROUP_ID
RUN groupadd -g $DOCKER_GROUP_ID docker
RUN apt-get install --no-install-recommends -y gpg-agent && rm -rf /var/lib/apt/lists/*;
#
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg >/tmp/gpg
RUN cat /tmp/gpg | apt-key add -

   #---sets up stable repository
#RUN    apt-get update
RUN    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

   #---installs Docker: Community Edition
#RUN    apt-get update
RUN apt-get -y --no-install-recommends install docker-ce && rm -rf /var/lib/apt/lists/*;


# Set the locale
RUN apt-get install -y --no-install-recommends \
    locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8 
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8 

RUN apt-get install -y --no-install-recommends \
    sudo \
    python3 \
    python3-pip \
    python3-setuptools && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir netaddr parse python-dateutil docker
#apt-get upgrade--fix-missing
RUN apt-get install -y --no-install-recommends \
     x11-xserver-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends \
     xterm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends \
     gnome-terminal && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
     less \
     iputils-ping \
     wget \
     vim \
     mupdf \
     xdg-utils && rm -rf /var/lib/apt/lists/*;

# For gnome-terminal
RUN apt-get install -y --no-install-recommends \
     dbus-x11 && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash labtainer
RUN echo "labtainer:labtainer" | chpasswd
RUN adduser labtainer sudo

RUN usermod -aG docker labtainer
RUN newgrp docker

#ensures that /var/run/docker.sock exists
RUN touch /var/run/docker.sock

#changes the ownership of /var/run/docker.sock
RUN chown root:docker /var/run/docker.sock

USER labtainer
WORKDIR /home/labtainer
