FROM bosh/cli2

RUN apt-get update
RUN apt-get install --no-install-recommends -y git curl wget && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://storage.googleapis.com/golang/go1.13.4.linux-amd64.tar.gz -o /go1.9.7.tar.gz
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
    sudo apt-get install --no-install-recommends -y nodejs git && rm -rf /var/lib/apt/lists/*;
RUN tar -C /usr/local -xzf /go1.9.7.tar.gz && rm /go1.9.7.tar.gz
RUN mkdir -p /root/go/bin
ENV GOPATH /root/go
ENV PATH $PATH:/usr/local/go/bin:/root/go/bin
RUN apt-get update && \
    apt-get install --no-install-recommends -y xvfb wget && \
    apt-get install --no-install-recommends -y xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg --unpack google-chrome-stable_current_amd64.deb && \
    apt-get install -f -y && \
    apt-get clean && \
    rm google-chrome-stable_current_amd64.deb && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/src/app && rm -rf /usr/src/app
