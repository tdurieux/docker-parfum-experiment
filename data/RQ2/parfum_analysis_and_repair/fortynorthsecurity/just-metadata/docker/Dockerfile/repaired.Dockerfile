# Dockerfile to build JustMetaData container
# Xavier Mertens <xavier@rootshell.be>
#
# To build:
#   docker build -t justmetadata \
#                [--build-arg SHODAN_APIKEY=xxxx] \
#                [--build-arg BING_APIKEY=xxxx] \
#                .
# To run:
#   docker run -it -v /local_dir:/data justmetadata
#

# Based on ubuntu:latest
FROM ubuntu:14.04
MAINTAINER Xavier Mertens <xavier@rootshell.be>

# Default settings
ARG SHODAN_APIKEY=""
ARG BING_APIKEY=""

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive

# Upgrade Ubuntu
RUN \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get autoremove -y && \
  apt-get clean

# Set the timezone
RUN echo "Europe/Brussels" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Usfeful tools
RUN \
  apt-get install --no-install-recommends -y python wget git && rm -rf /var/lib/apt/lists/*;

# Set the environment
RUN \
  apt-get install --no-install-recommends -y python-pip && \
  easy_install -U pip && \
  apt-get install -y --no-install-recommends python-colorama && \
  pip install --no-cache-dir ipwhois && \
  pip install --no-cache-dir ipwhois --upgrade && \
  pip install --no-cache-dir requests && \
  pip install --no-cache-dir requests --upgrade && \
  pip install --no-cache-dir shodan && \
  pip install --no-cache-dir shodan --upgrade && \
  pip install --no-cache-dir netaddr && \
  pip install --no-cache-dir netaddr --upgrade && rm -rf /var/lib/apt/lists/*;

# Install the script
WORKDIR /root
RUN \
  git clone https://github.com/xme/Just-Metadata

# Install your personal API keys
WORKDIR /root/Just-Metadata
RUN \
  sed -i "s/self.api_key = \"\"/self.api_key = \"$SHODAN_APIKEY\"/" modules/intelgathering/get_shodn.py && \
  sed -i "s/self.api_key = \"\"/self.api_key = \"$BING_APIKEY\"/" modules/intelgathering/get_bing.py



# make it run
ENTRYPOINT ["python" , "JustMetadata.py"]
