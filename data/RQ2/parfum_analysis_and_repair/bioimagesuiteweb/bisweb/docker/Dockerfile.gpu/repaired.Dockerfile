# Base
FROM tensorflow/tensorflow:1.14.0-gpu-py3

MAINTAINER Xenios Papademetris <xpapademetris@gmail.com>

# install system-wide deps for python and node
RUN apt-get -yqq update
RUN apt-get install --no-install-recommends -yqq python-pip python-dev python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq unzip g++ gcc cmake cmake-curses-gui && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq curl openjdk-8-jdk git make dos2unix && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install --no-install-recommends -yq nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq doxygen graphviz gosu && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq libgtk-3-dev libxss1 && rm -rf /var/lib/apt/lists/*;

# python packages
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir numpy nibabel

# Node.js globals
RUN npm install -g gulp mocha rimraf && npm cache clean --force;
RUN npm install -g electron --unsafe-perm=true --allow-root && npm cache clean --force;
RUN npm install -g electron-packager && npm cache clean --force;

RUN chown root /usr/lib/node_modules/electron/dist/chrome-sandbox
RUN chmod 4755 /usr/lib/node_modules/electron/dist/chrome-sandbox

# Expose server
EXPOSE 8080

# Copy bash.bashrc
COPY bash.bashrc /etc/bash.bashrc
RUN dos2unix /etc/bash.bashrc

#Entry point
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN dos2unix /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Configuration script
COPY biswebconfig.gpu.sh /usr/local/bin/biswebconfig.sh
RUN dos2unix /usr/local/bin/biswebconfig.sh
RUN chmod +x /usr/local/bin/biswebconfig.sh

# Instal tfjs converter
RUN pip3 install --no-cache-dir tensorflowjs==1.2.10.1


# Specify entrypoint --
ENTRYPOINT ["bash", "/usr/local/bin/entrypoint.sh"]






