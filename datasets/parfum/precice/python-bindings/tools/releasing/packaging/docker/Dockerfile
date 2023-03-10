# Dockerfile to build a ubuntu image containing the installed Debian package of a release 
ARG branch=develop
ARG from=precice/precice:latest
FROM $from

USER root
# Installing necessary dependencies
RUN apt-get -qq update && apt-get -qq install \
    apt-utils && \
    apt-get -qq install \
    software-properties-common \
    git \
    sudo \
    python3-dev \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*

## Needed, because precice/precice:latest does not create a user? See also https://github.com/precice/precice/pull/1090
## ------>
# Create user precice
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} precice \
    && useradd -u ${uid} -g ${gid} -m -s /bin/bash precice \
    && sudo usermod -a -G sudo precice

# Setup passwordless sudo
RUN echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to the user precice
USER precice
WORKDIR /home/precice
ENV USER=precice

# Use bash instead of default sh
SHELL ["/bin/bash", "-c"]
## <-----

# Upgrade pip to newest version (pip version from 18.04 apt-get is outdated)
RUN python3 -m pip install --user --upgrade pip

# Rebuild image if force_rebuild after that command
ARG CACHEBUST
ARG branch=develop

# Builds the precice python bindings for python3
RUN pip3 install --user git+https://github.com/precice/python-bindings.git@$branch
