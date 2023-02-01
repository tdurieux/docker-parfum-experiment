FROM ubuntu:artful

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD . /choreonoid

RUN cd /choreonoid && \
    echo "y" | ./misc/script/install-requisites-ubuntu-17.10.sh && \
    cmake . && \
    make && \
    make install
