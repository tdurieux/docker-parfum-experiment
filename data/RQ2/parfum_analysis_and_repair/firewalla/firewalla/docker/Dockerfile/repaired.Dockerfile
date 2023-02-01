# DOCKER-VERSION 1.0.0
FROM resin/rpi-raspbian

# install required packages, in one command
RUN apt-get update && \
    apt-get install --no-install-recommends -y python-dev && \
    apt-get install --no-install-recommends -y cmake make gcc g++ flex bison libpcap-dev libssl-dev swig zlib1g-dev && \
    apt-get install --no-install-recommends -y git subversion libudev-dev make build-essential git-core python2.7 pkg-config libssl-dev && \
    apt-get install --no-install-recommends -y curl && \
    apt-get install -y --no-install-recommends bluetooth bluez blueman && \
    apt-get install -y --no-install-recommends ca-certificates && \
    apt-get install --no-install-recommends -y dsniff && \
    apt-get install --no-install-recommends -y nmap && \
    apt-get install --no-install-recommends -y net-tools && \
    curl -f -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install forever -g && \
    npm install xml-json -g && \
    mkdir /usr/local/bro && \
    mkdir /opt/critical-stack/ && \
    mkdir /blog && \
    mkdir /bspool && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
COPY ./tmp/bro/ /usr/local/bro/
COPY ./tmp/critical-stack/ /opt/critical-stack/
COPY ./ /root/firewalla/
RUN rm -r -f /root/firewalla/tmp

env PATH ~/bin:$PATH
ENV PYTHON /usr/bin/python2

WORKDIR /root/firewalla/scripts
#RUN ./camerasetup.2


# run application
#CMD ["/bin/bash"]
#ENTRYPOINT ["node-red-pi","-v","--max-old-space-size=128"]
