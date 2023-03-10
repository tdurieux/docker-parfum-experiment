# Base-image for python on any machine using a template variable
FROM balenalib/%%RESIN_MACHINE_NAME%%-python:2.7

# Set the maintainer
LABEL maintainer="Joe Roberts <joe@resin.io>, Zahari Petkov <zahari@resin.io>"

# Enable systemd init system
ENV INITSYSTEM on

# Set the working directory
WORKDIR /usr/src/app

# We have split up the resin-wifi-connect and Display-O-Tron HAT configuration to make clear
# the different parts needed. In your dockerfile you should combine these steps to reduce
# the number of layers.

# -- Start of resin-wifi-connect section -- #

# Set the device type environment variable using Dockerfile templates
ENV DEVICE_TYPE=%%RESIN_MACHINE_NAME%%

# Use apt-get to install dependencies
RUN apt-get update && apt-get install -yq --no-install-recommends \
    dnsmasq curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install resin-wifi-connect
RUN curl -f https://api.github.com/repos/balena-io/wifi-connect/releases/latest -s \
    | grep -hoP 'browser_download_url": "\K.*%%RESIN_ARCH%%\.tar\.gz' \
    | xargs -n1 curl -Ls \
    | tar -xvz -C /usr/src/app/

# -- End of resin-wifi-connect section -- #

# Copy everything into the container
COPY . ./

# Start application
CMD ["bash", "start.sh"]
