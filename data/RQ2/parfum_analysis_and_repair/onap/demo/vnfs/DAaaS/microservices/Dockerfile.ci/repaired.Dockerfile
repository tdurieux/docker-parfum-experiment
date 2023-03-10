FROM ubuntu:18.04

RUN apt-get -yqq update && apt-get -yqq --no-install-recommends install lsb-release apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get -yqq update && apt-get -yqq --no-install-recommends install docker-ce docker-ce-cli mercurial && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*
WORKDIR /app

#### Go v1.12.5
ENV GOLANG_VERSION 1.12.5
RUN curl -f -sSL https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz \
		| tar -v -C /usr/local -xz
ENV PATH /usr/local/go/bin:$PATH
RUN mkdir -p /go/src /go/bin && chmod -R 777 /go
ENV GOROOT /usr/local/go
ENV GOPATH /app/go
ENV PATH /app/go/bin:$PATH
#### Go v1.12.5

RUN git clone https://github.com/onap/demo.git
WORKDIR /app/demo/vnfs/DAaaS/microservices
ENV RELEASE_VERSION=v0.9.0
RUN curl -f -OJL https://github.com/operator-framework/operator-sdk/releases/download/${RELEASE_VERSION}/operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu
RUN chmod +x operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu && cp operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu /usr/local/bin/operator-sdk && rm operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu
ENV GO111MODULE=on