# Debian
#
# VERSION               1.1
FROM      debian:squeeze
MAINTAINER Jon Schipp <jonschipp@gmail.com>

# Variables
ENV VIRTUSER opennsm

# Install general tools
RUN apt-get update -qq
RUN apt-get install --no-install-recommends -yq sudo wget gawk git nano vim emacs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq libcap-ng-dev libcap2-bin && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq lsof htop dstat sysstat iotop strace ltrace && rm -rf /var/lib/apt/lists/*;

# User configuration
RUN adduser --disabled-password --gecos "" $VIRTUSER

# Passwords
RUN echo "$VIRTUSER:$VIRTUSER" | chpasswd
RUN echo "root:opennsm" | chpasswd

# Sudo
RUN usermod -aG sudo $VIRTUSER
