# Base
FROM ubuntu:18.04

MAINTAINER Xenios Papademetris <xpapademetris@gmail.com>

# install system-wide deps for python and node
RUN apt-get -yqq update
RUN apt-get install --no-install-recommends -yqq python-pip python-dev python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq unzip g++ gcc cmake cmake-curses-gui && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq curl openjdk-8-jdk git make dos2unix && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install --no-install-recommends -yq nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq doxygen graphviz gosu && rm -rf /var/lib/apt/lists/*;

# python packages
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir numpy nibabel

# Node.js globals
RUN npm install -g gulp mocha rimraf electron-packager && npm cache clean --force;

# Expose server
EXPOSE 8080

# dotbashrc and entrypoint file
COPY bash.bashrc /etc/bash.bashrc
RUN dos2unix /etc/bash.bashrc

#Entry point
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN dos2unix /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Configuration script
COPY biswebconfig.sh /usr/local/bin/biswebconfig.sh
RUN dos2unix /usr/local/bin/biswebconfig.sh
RUN chmod +x /usr/local/bin/biswebconfig.sh

# Specify entrypoint --
ENTRYPOINT ["bash", "/usr/local/bin/entrypoint.sh"]






