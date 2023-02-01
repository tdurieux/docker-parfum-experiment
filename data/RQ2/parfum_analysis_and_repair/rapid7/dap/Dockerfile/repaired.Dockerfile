FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
  ca-certificates \
  ruby \
  ruby-dev \
  git \
  make \
  g++ \
  libffi-dev \
  libgeoip-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libxml2-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN gem install bundler

RUN apt-get install --no-install-recommends -y wget && mkdir -p /var/lib/geoip && cd /var/lib/geoip && wget https://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && gunzip GeoLiteCity.dat.gz && mv GeoLiteCity.dat geoip.dat && rm -rf /var/lib/apt/lists/*;

RUN gem install dap -s https://github.com/rapid7/dap

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["dap"]
