FROM ubuntu:17.10

RUN apt-get update
RUN apt-get install --no-install-recommends -y \
    build-essential \
    git \
    dbus \
    libsystemd-dev \
    libpam-systemd \
    systemd-container \
    curl \
    ca-certificates \
    gnupg2 \
    apt-transport-https \
    software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
       $(lsb_release -cs) \
       stable" && \
    apt-get update && \
    apt-get -y --no-install-recommends install docker-ce && rm -rf /var/lib/apt/lists/*;
RUN ln -s /bin/sleep /usr/bin/sleep
RUN curl -f -sSL https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz | tar xz -C /usr/local

ENV PATH=/usr/local/go/bin:$PATH
ENV GOROOT=/usr/local/go
ENV GOPATH=/go

VOLUME /go
#VOLUME /run/soil
#VOLUME /var/lib/soil

# docker run -d --name=sdt --privileged -v ${PWD}:/go/src/github.com/akaspin/soil test:1 /bin/systemd --system
