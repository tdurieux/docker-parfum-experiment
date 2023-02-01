FROM bosh/cli2

RUN apt-get update
RUN apt-get install -y git curl wget
RUN curl https://storage.googleapis.com/golang/go1.12.4.linux-amd64.tar.gz -o /go1.9.7.tar.gz
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
    sudo apt-get install -y nodejs git
RUN tar -C /usr/local -xzf /go1.9.7.tar.gz
RUN mkdir -p /root/go/bin
ENV GOPATH /root/go
ENV PATH $PATH:/usr/local/go/bin:/root/go/bin
RUN apt-get update && \
    apt-get install -y xvfb wget && \
    apt-get install -y xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg --unpack google-chrome-stable_current_amd64.deb && \
    apt-get install -f -y && \
    apt-get clean && \
    rm google-chrome-stable_current_amd64.deb && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/src/app
