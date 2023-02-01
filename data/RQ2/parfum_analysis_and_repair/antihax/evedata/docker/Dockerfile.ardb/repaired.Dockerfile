FROM ubuntu:14.04

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y git make gcc g++ automake autoconf libbz2-dev libz-dev wget && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/yinqiwen/ardb.git && \
    cd ardb && \
    make && \
    cp src/ardb-server /usr/bin && \
    mkdir -p /etc/ardb && \
    cp ardb.conf /etc/ardb && \
    cd .. && \
    yes | rm -r ardb

RUN sed -e 's@home.*@home /var/lib/ardb@' \
        -e 's/loglevel.*/loglevel info/' -i /etc/ardb/ardb.conf

RUN sed -i 's/16379/6379/g' /etc/ardb/ardb.conf

RUN echo 'trusted-ip *.*.*.*' >> /etc/ardb/ardb.conf

WORKDIR /var/lib/ardb

EXPOSE 6379
ENTRYPOINT /usr/bin/ardb-server /etc/ardb/ardb.conf