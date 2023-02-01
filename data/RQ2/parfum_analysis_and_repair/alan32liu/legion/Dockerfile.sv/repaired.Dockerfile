FROM ubuntu:bionic

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install python3 python3-setuptools python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
RUN git clone https://github.com/Alan32Liu/claripy.git
RUN git clone https://github.com/Alan32Liu/angr.git

RUN pip3 install --no-cache-dir --target lib ./claripy ./angr

