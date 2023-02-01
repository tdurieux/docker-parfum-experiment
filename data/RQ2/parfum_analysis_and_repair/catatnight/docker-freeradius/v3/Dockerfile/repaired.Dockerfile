From ubuntu:trusty
MAINTAINER Elliott Ye

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Upgrade base system packages
RUN apt-get update

### Start editing ###
# Install package here for cache
RUN apt-get -y --no-install-recommends install software-properties-common \
    && add-apt-repository ppa:freeradius/stable-3.0 \
    && apt-get update \
    && apt-get -y --no-install-recommends install freeradius freeradius-mysql && rm -rf /var/lib/apt/lists/*;

# Add files
ADD install.sh /opt/install.sh

# Run
CMD /opt/install.sh;/usr/sbin/freeradius -f
