FROM ubuntu

MAINTAINER Ryan Kurte <ryankurte@gmail.com>
LABEL Description="Qemu based emulation for raspberry pi using loopback images"

# Update package repository
RUN apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated \
    qemu \
    qemu-user-static \
    binfmt-support \
    parted \
    vim \
    sudo && rm -rf /var/lib/apt/lists/*; # Install required packages








# Clean up after apt
RUN apt-get clean
RUN rm -rf /var/lib/apt

# Setup working directory
RUN mkdir -p /usr/rpi
WORKDIR /usr/rpi

# Setup home directory
RUN mkdir -p /home/pi

COPY scripts/* /usr/rpi/


