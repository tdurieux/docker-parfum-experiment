### misc ###

FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install --no-install-recommends -y wget git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install make cmake build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libboost-all-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;

### forexconnect ###

RUN mkdir -p /opt/forexconnect

WORKDIR /opt/forexconnect

RUN wget https://fxcodebase.com/bin/forexconnect/1.4.1/ForexConnectAPI-1.4.1-Linux-x86_64.tar.gz
RUN tar -xzf ForexConnectAPI-1.4.1-Linux-x86_64.tar.gz && rm ForexConnectAPI-1.4.1-Linux-x86_64.tar.gz

ENV FOREXCONNECT_ROOT /opt/forexconnect/ForexConnectAPI-1.4.1-Linux-x86_64


### python-forexconnect###

RUN git clone https://github.com/neka-nat/python-forexconnect.git

RUN cd python-forexconnect; mkdir build; cd build; cmake .. -DDEFAULT_FOREX_URL="http://www.fxcorporate.com/Hosts.jsp"; make install

ENV LD_LIBRARY_PATH /opt/forexconnect/python-forexconnect/build/forexconnect/sample_tools/lib/:/opt/forexconnect/ForexConnectAPI-1.4.1-Linux-x86_64/lib
