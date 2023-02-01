FROM ubuntu:16.04

MAINTAINER Shanqing Cai <cais@google.com>

# Copy and run the install scripts.
COPY install/*.sh /install/
RUN /install/install_bootstrap_deb_packages.sh
RUN /install/install_deb_packages.sh

RUN pip install --no-cache-dir --upgrade numpy

# Install golang
RUN add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
RUN apt-get update && apt-get install --no-install-recommends -y golang && rm -rf /var/lib/apt/lists/*;
