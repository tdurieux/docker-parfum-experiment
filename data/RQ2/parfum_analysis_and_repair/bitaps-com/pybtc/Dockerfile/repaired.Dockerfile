FROM ubuntu:18.04
MAINTAINER Aleksey Karpov <admin@bitaps.com>
RUN echo "nameserver 8.8.8.8" > /etc/resolv.comf
RUN apt-get update
# install python

RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install pkg-config libtool autotools-dev automake pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir bit
COPY ./ /pybtc
RUN cd pybtc; python3 setup.py install
ENTRYPOINT ["/bin/bash"]