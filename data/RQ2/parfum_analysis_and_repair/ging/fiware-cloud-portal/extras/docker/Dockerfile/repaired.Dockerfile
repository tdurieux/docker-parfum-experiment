FROM ubuntu:14.04

MAINTAINER FIWARE Cloud Portal Team. DIT-UPM

WORKDIR /opt

# Install Ubuntu dependencies
RUN sudo apt-get update && \
	sudo apt-get install --no-install-recommends make g++ software-properties-common python-software-properties -y && \
	sudo add-apt-repository ppa:chris-lea/node.js -y && \
	sudo apt-get update && \
	sudo apt-get install --no-install-recommends nodejs git ruby1.9.1 -y && \
	sudo gem install sass -v 3.2.12 -y && rm -rf /var/lib/apt/lists/*;

# Download latest version of the code and install npm dependencies
RUN git clone https://github.com/ging/fiware-cloud-portal.git && \
	cd fiware-cloud-portal && \
	git checkout tags/5.4 && \
	npm install && \
	./node_modules/grunt-cli/bin/grunt && npm cache clean --force;

# Run Cloud Portal
WORKDIR /opt/fiware-cloud-portal
CMD ["sudo", "node", "server.js"]
