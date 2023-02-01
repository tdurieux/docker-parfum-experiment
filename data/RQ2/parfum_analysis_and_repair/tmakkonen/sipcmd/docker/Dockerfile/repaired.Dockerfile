FROM debian:stretch-slim


LABEL Description="SIP" Vendor="Daniel Drexlmaier" Version="1.6" maintainer="dd@dbe.academy"
ENV DEBIAN_FRONTEND noninteractive
ENV LOCALE en_EN.UTF-8


RUN apt-get update && apt-get -y upgrade && apt-get install --no-install-recommends -y vim git libopal-dev libpt-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/tmakkonen/sipcmd.git && \
cd sipcmd && \
 apt install --no-install-recommends -y make g++ && rm -rf /var/lib/apt/lists/*;

#COPY alert1.wav /sipcmd/alert1.wav
#COPY alert2.wav /sipcmd/alert2.wav
#COPY alert3.wav /sipcmd/alert3.wav
#COPY Makefile /sipcmd/Makefile

RUN cd sipcmd && make
CMD tail -f /etc/debian_version

EXPOSE 5060
