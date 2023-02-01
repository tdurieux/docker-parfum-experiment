FROM ubuntu:latest

MAINTAINER Tige Phillips <tige@tigelane.com>

RUN apt-get update
RUN apt-get -y upgrade

## Python
# RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python3 python3-setuptools

## Python pip
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive pip3 --no-cache-dir install --upgrade pip

## git
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install git && rm -rf /var/lib/apt/lists/*;

# acitool install
RUN DEBIAN_FRONTEND=noninteractive pip3 --no-cache-dir install git+https://github.com/carlniger/acitool

WORKDIR /root
RUN mkdir -p /root/acitool
COPY ./ /root/acitool/
WORKDIR /root/acitool/

RUN python3 setup.py install

# Drop users into root dir when running
WORKDIR /root/acitool
