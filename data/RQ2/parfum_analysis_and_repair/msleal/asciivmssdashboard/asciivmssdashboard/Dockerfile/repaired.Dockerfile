#Dockerfile for ASCiiVMSSDashboard
#Copyright(c) 2016, Marcelo Leal

#To build it, type (example):
#>sudo docker build -t msleal/asciivmssdashboard:test .
FROM ubuntu:14.04
MAINTAINER Marcelo Leal <msl@eall.com.br>
RUN apt-get update
RUN apt-get install --no-install-recommends -y git && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir azurerm
RUN pip install --no-cache-dir --upgrade urllib3 && pip install --no-cache-dir --upgrade requests
RUN cd /tmp/ && wget https://sourceforge.net/projects/pyunicurses/files/latest/download -O unicurses.zip
RUN cd /tmp/ && unzip unicurses.zip
RUN cd /tmp/ && cd UniCurses-* && python setup.py install
RUN adduser --disabled-password --gecos "" architect
RUN su - architect -c "git clone https://github.com/msleal/asciivmssdashboard.git"
