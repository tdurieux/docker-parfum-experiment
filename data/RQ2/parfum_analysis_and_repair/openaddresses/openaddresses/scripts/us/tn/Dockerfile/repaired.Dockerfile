FROM ubuntu:14.04

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y git chef zip && rm -rf /var/lib/apt/lists/*;

RUN git clone -b 2.x https://github.com/openaddresses/machine.git /tmp/machine && \
    cd /tmp/machine && chef/run.sh openaddr

COPY cache.sh /usr/local/bin/run-cache
