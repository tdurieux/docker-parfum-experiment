# Base image:
FROM ubuntu:focal

# Install eCAL from PPA:
RUN apt-get update && \
	apt-get install --no-install-recommends -y software-properties-common && \
	rm -rf /var/lib/apt/lists/*
RUN add-apt-repository ppa:ecal/ecal-latest
RUN apt-get install --no-install-recommends -y ecal && rm -rf /var/lib/apt/lists/*;

# Install dependencies for compiling the hello world examples.
# You can omit this, if you don't want to build applications in the container.
RUN apt-get install --no-install-recommends -y cmake g++ libprotobuf-dev protobuf-compiler && rm -rf /var/lib/apt/lists/*;

# Set network_enabled = true in ecal.ini.
# You can omit this, if you only need local communication.
RUN awk -F"=" '/^network_enabled/{$2="= true"}1' /etc/ecal/ecal.ini > /etc/ecal/ecal.tmp && \
	rm /etc/ecal/ecal.ini && \
	mv /etc/ecal/ecal.tmp /etc/ecal/ecal.ini

# Print the eCAL config
RUN ecal_config