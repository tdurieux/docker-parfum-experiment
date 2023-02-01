FROM ubuntu:bionic

# https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
RUN apt-get update && \
    apt-get -y --no-install-recommends install apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get -y --no-install-recommends install docker-ce git libftdi1-2 libusb-1.0-0 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD mos /usr/local/bin

ENTRYPOINT ["/usr/local/bin/mos"]
