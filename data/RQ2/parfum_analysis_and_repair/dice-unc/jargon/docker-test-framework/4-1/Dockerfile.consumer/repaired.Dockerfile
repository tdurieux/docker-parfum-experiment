#
# iRODS Provider Image.
#
#
# iRODS Provider Image.
#
FROM ubuntu:16.04

# TODO: Remove this line when apt gets its stuff together
RUN sed --in-place --regexp-extended "s/(\/\/)(archive\.ubuntu)/\1nl.\2/" /etc/apt/sources.list

# Install pre-requisites
RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo wget lsb-release apt-transport-https postgresql vim python-pip libfuse2 unixodbc rsyslog less && \
    pip install --no-cache-dir xmlrunner && rm -rf /var/lib/apt/lists/*;


# Grab .debs and install
RUN wget https://files.renci.org/pub/irods/releases/4.1.12/ubuntu14/irods-runtime-4.1.12-ubuntu14-x86_64.deb && \
    dpkg -i irods-runtime-4.1.12-ubuntu14-x86_64.deb && \
    wget https://files.renci.org/pub/irods/releases/4.1.12/ubuntu14/irods-resource-4.1.12-ubuntu14-x86_64.deb && \
    dpkg -i irods-resource-4.1.12-ubuntu14-x86_64.deb

COPY irods_consumer.input /

# Set command to execute when launching the container.
ADD start_consumer.sh /
RUN chmod u+x /start_consumer.sh
RUN curl -fSL https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz -o dockerize-linux-amd64-v0.6.1.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz && rm dockerize-linux-amd64-v0.6.1.tar.gz
CMD dockerize -wait tcp://icat.example.org:1247 -timeout 250s /start_consumer.sh
