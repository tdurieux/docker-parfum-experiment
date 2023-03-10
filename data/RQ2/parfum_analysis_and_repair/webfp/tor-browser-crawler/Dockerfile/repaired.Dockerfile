# This dockerfile allows to run an crawl inside a docker container

# Pull base image.
FROM debian:stable-slim

# Install required packages.
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --assume-yes --yes install sudo build-essential autoconf git zip unzip xz-utils && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --assume-yes --yes install libtool libevent-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --assume-yes --yes install python python-dev python-setuptools python-pip && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --assume-yes --yes install net-tools ethtool tshark libpcap-dev && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --assume-yes --yes install xvfb firefox-esr && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Install python requirements.
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir requests

# add host user to container
RUN adduser --system --group --disabled-password --gecos '' --shell /bin/bash docker

# download geckodriver
ADD https://github.com/mozilla/geckodriver/releases/download/v0.17.0/geckodriver-v0.17.0-linux64.tar.gz /bin/
RUN tar -zxvf /bin/geckodriver* -C /bin/
ENV PATH /bin/geckodriver:$PATH

# add setup.py
RUN git clone https://gist.github.com/852eca0c5820eb7998432e39effcf73a.git /home/docker/tbb_setup
RUN python /home/docker/tbb_setup/setup.py 6.0.6

# Set the display
ENV DISPLAY $DISPLAY
