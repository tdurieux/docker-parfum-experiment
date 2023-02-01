FROM sitespeedio/visualmetrics

MAINTAINER Peter Hedenskog <peter@soulgalore.com>

RUN apt-get update -y && apt-get install -y \
  build-essential \
  ca-certificates \
  curl \
  gcc \
  default-jre-headless \
  --no-install-recommends --force-yes && rm -rf /var/lib/apt/lists/*

# Install nodejs
RUN curl -f --silent --location https://deb.nodesource.com/setup_4.x | bash - && \
  apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;

# And get Browsertime
RUN npm install browsertime@1.0.0-alpha.17 -g && npm cache clean --force;

ADD ./scripts/ /home/root/scripts

VOLUME /browsertime

WORKDIR /browsertime
