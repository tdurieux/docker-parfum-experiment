FROM ubuntu:18.04

RUN apt update && \
    apt install --no-install-recommends -y g++ make libboost1.65-all-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD src /tmp/src
ADD Makefile /tmp/Makefile

WORKDIR /tmp/

RUN make

ENTRYPOINT ["sleep", "infinity"]
