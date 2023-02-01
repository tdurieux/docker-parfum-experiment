FROM python:2.7
MAINTAINER James Williams "williams_jt@yahoo.com"
RUN wget -O cf-cli.deb https://cli.run.pivotal.io/stable?release=debian64

RUN dpkg -i cf-cli.deb

RUN apt-get -y update
RUN apt-get install -y jq
RUN apt-get install -y bc

RUN git clone https://github.com/Pivotal-Field-Engineering/ephemerol
RUN cd ./ephemerol && pip install -r requirements.txt

WORKDIR /data