FROM node:latest

# Get dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
        gzip \
        git \
        curl \
        python \
        libssl-dev \
        pkg-config \
        build-essential && rm -rf /var/lib/apt/lists/*;

# Grap the latest version
RUN cd /opt && git clone https://github.com/ether/etherpad-lite.git etherpad

# Configuration
ADD conf/settings.json /opt/etherpad/settings.json

WORKDIR /opt/etherpad
ENTRYPOINT ["bin/run.sh", "--root"]