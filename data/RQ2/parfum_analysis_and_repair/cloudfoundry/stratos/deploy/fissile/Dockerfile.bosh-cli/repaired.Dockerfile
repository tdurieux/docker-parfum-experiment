FROM splatform/bosh-cli

RUN curl -f https://storage.googleapis.com/golang/go1.13.4.linux-amd64.tar.gz -o go1.13.4.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.13.4.linux-amd64.tar.gz && rm go1.13.4.linux-amd64.tar.gz
RUN curl -f https://deb.nodesource.com/setup_6.x -o install_node.sh
RUN chmod +x install_node.sh && \
    ./install_node.sh && \
    sudo apt-get install --no-install-recommends -y nodejs wget locales && rm -rf /var/lib/apt/lists/*;
RUN echo 'export BOSH_LOG_LEVEL=info' >> /etc/bash.bashrc && \
     echo 'export LANG=en_US.UTF-8' >> /etc/bash.bashrc && \
     echo 'export LC_ALL=en_US.UTF-8' >> /etc/bash.bashrc && \
     locale-gen en_US en_US.UTF-8 && \
     update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
     dpkg-reconfigure --frontend=noninteractive locales
