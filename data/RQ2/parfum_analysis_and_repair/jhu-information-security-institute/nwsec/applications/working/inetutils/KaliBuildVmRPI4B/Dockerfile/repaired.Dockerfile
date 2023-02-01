# Description:
#   This build environment example Dockerfile creates a container for building inetutils-telnetd
# Usage:
#   From this directory, run $ sudo docker build -t tkalibuildenv .
# Useful websites:
#   https://www.kali.org/docs/development/recompiling-the-kali-linux-kernel/

# This Dockerfile assumes that you have extracted the cross-compiler toolchain on your host in /opt/gnu

# By default, runs as root

# List of containers for kali are here:
# https://gitlab.com/kalilinux/build-scripts/kali-docker/container_registry

# Pull kali:2019.4
FROM registry.gitlab.com/kalilinux/build-scripts/kali-docker/kali:2019.4

RUN apt-get update && apt-get install --no-install-recommends build-essential autotools-dev automake autoconf texinfo -y && rm -rf /var/lib/apt/lists/*; # Get the dependencies for git, then get openssl


# Create a directory for mounting gnu toolchain with cross-compiler from a host folder
RUN mkdir -p /opt/gnu
RUN useradd -ms /bin/bash dummy
COPY cross-compile.sh /home/dummy/.

# Finished!
RUN echo 'Container is ready, run it using $ sudo docker run --name kalibuildenv -v /opt/gnu:/opt/gnu -it tkalibuildenv:latest'