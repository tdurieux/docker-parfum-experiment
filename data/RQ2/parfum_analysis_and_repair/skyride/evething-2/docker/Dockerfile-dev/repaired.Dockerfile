# Pull base image.
FROM ubuntu:14.04

MAINTAINER Eric Gillingham "Eric.J.Gillingham@jpl.nasa.gov"

# Setup unprivileged user
RUN adduser --disabled-password --gecos '' evething && \
    mkdir /evething-env && \
    mkdir /evething && \
    chown evething /evething-env && \
    chown evething /evething

# Install.
RUN apt-get update && \
    apt-get install --no-install-recommends -y python2.7 python2.7-dev python-virtualenv python-pip \
                    libpq-dev \
                    nodejs nodejs-legacy npm \
                    build-essential wget && rm -rf /var/lib/apt/lists/*;

USER evething
WORKDIR /evething

COPY requirements.txt /evething/
COPY docker/requirements-docker.txt docker/requirements-docker-dev.txt /evething/docker/
# Install python deps into virtualenv, and activate at login
RUN /usr/bin/virtualenv /evething-env && \
    . /evething-env/bin/activate && \
    pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -r /evething/requirements.txt -r -r && \
    echo '. /evething-env/bin/activate' >> $HOME/.bashrc

# Add node_modules to PATH
RUN echo 'export PATH=${PATH}:/evething/node_modules/.bin' >> $HOME/.bashrc

EXPOSE 8000

# Define default command, this gets overwritten by docker-compose
CMD ["/evething/docker/devserver.sh"]
