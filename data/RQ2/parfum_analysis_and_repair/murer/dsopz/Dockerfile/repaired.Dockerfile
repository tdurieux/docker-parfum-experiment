FROM ubuntu:16.04

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install openssl curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pycrypto

#ENV GOPATH=/go

#RUN mkdir /go && \
#    go get github.com/github-release/github-release