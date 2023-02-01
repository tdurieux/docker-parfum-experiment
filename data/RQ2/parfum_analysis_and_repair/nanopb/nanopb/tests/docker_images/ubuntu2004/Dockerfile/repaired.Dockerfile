FROM ubuntu:focal

RUN apt -y update
RUN apt -y upgrade
RUN apt -y dist-upgrade
RUN apt -y autoremove
RUN apt -y install --fix-missing
RUN apt -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install git scons build-essential g++ && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install protobuf-compiler python3.8 python3-protobuf && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1 && update-alternatives --set python /usr/bin/python3.8

RUN git clone https://github.com/nanopb/nanopb.git
RUN cd nanopb/tests && scons

