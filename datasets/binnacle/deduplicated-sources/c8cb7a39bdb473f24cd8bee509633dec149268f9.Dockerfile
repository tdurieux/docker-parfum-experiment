# Dockerfile for use with docker-compose

FROM debian:stretch-slim

RUN apt-get -y update

# Install Python
RUN apt-get -y install python3
RUN apt-get -y install apt-transport-https
RUN apt-get -y install curl
RUN apt-get -y install gnupg2
RUN apt-get -y install git

# Install Tesla API Scraper
RUN apt-get -y install python3-pip
WORKDIR /
RUN pip3 install influxdb

RUN git clone https://github.com/tkrajina/srtm.py
WORKDIR srtm.py
RUN python3 ./setup.py install
WORKDIR /

ARG CACHEBUST=1
ARG gitversion
# Configure it
RUN git clone https://github.com/lephisto/tesla-apiscraper
WORKDIR tesla-apiscraper
RUN git pull
RUN git checkout $gitversion
# Define our startup script
RUN echo "#!/bin/bash" > /start.sh
RUN echo "python3 /tesla-apiscraper/apiscraper.py" >> /start.sh
RUN chmod +x /start.sh

# Run it
EXPOSE 8023
CMD /start.sh
