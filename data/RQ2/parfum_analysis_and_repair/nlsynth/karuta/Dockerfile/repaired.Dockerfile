FROM ubuntu:latest
MAINTAINER Yusuke Tabata <tabata.yusuke@gmail.com>

RUN apt-get update && apt-get -y update
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir gyp-next
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN git clone --depth 1 --recursive https://github.com/nlsynth/karuta
WORKDIR karuta
RUN python3 configure
RUN make
RUN make install

ENTRYPOINT bash
