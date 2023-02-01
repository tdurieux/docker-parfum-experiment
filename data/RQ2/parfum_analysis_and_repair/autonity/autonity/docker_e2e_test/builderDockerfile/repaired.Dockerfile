FROM ubuntu:18.04

RUN apt-get update -y && apt-get install --no-install-recommends -y build-essential wget make && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp && \
    wget https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz && \
    tar -xvf go1.14.4.linux-amd64.tar.gz && \
    mv go /usr/local && rm go1.14.4.linux-amd64.tar.gz

ENV PATH="${PATH}:/usr/local/go/bin"
