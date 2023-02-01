# Get base image
FROM ubuntu:15.04

# Install the required packages
RUN apt-get update && apt-get -y --no-install-recommends install python-pip rabbitmq-server git wget clamav && pip install --no-cache-dir Flask && pip install --no-cache-dir elasticsearch && pip install --no-cache-dir pika && pip install --no-cache-dir -U flask-cors && rm -rf /var/lib/apt/lists/*;

# Install docker
RUN wget -qO- https://get.docker.com/ | sh

# Package the code
RUN git clone https://github.com/BU-NU-CLOUD-SP16/Container-Code-Classification /usr/local/ccs

WORKDIR /usr/local/ccs/scripts

# Install sdhash
RUN /usr/local/ccs/scripts/install_sdhash.sh

# Update the code and clamav database
RUN git pull && freshclam

CMD ["/bin/bash", "start_services.sh"]
