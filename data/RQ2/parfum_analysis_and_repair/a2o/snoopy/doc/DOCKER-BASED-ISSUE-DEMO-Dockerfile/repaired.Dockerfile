FROM jrei/systemd-ubuntu:20.04

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# Install Snoopy-installation prerequisites
RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# Install Snoopy
RUN wget -O install-snoopy.sh https://github.com/a2o/snoopy/raw/install/install/install-snoopy.sh \
    && chmod 755 install-snoopy.sh \
    && ./install-snoopy.sh stable

# Define systemd as the default command
ENTRYPOINT ["/lib/systemd/systemd"]
