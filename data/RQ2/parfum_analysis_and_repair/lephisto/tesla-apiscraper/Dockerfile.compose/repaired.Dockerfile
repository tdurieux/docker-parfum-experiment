# Dockerfile for use with docker-compose

FROM debian:stretch-slim

RUN apt-get -y update

# Install Python
RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

# Install Tesla API Scraper
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
WORKDIR /
RUN pip3 install --no-cache-dir influxdb

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
