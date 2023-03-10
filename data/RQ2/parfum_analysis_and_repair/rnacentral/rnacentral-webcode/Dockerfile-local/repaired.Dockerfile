#------------------------------------------------------------------------------
#
# This Dockerfile is meant for local development.
#
#-------------------------------------------------------------------------------

FROM python:3.8-slim

RUN apt-get update && apt-get install --no-install-recommends -y \
    g++ \
    build-essential \
    curl \
    tar \
    git \
    vim \
    supervisor \
    libpq-dev && \
    rm -rf /var/lib/apt/lists/*

ENV RNACENTRAL_LOCAL=/srv/rnacentral/local
ENV SUPERVISOR_CONF_DIR=/srv/rnacentral/supervisor

# Create folders
RUN \
    mkdir -p $RNACENTRAL_LOCAL && \
    mkdir -p $SUPERVISOR_CONF_DIR && \
    mkdir /srv/rnacentral/log && \
    mkdir /srv/rnacentral/static


# Install node.js
RUN \
    cd $RNACENTRAL_LOCAL && \
    curl -f -sL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Set work directory
ENV RNACENTRAL_HOME=/srv/rnacentral/rnacentral-webcode
RUN mkdir -p $RNACENTRAL_HOME
WORKDIR $RNACENTRAL_HOME

# Copy requirements
COPY rnacentral/requirements* .

# Install requirements
RUN pip3 install --no-cache-dir -r requirements.txt && pip3 install --no-cache-dir -r requirements_dev.txt

# Install NPM dependencies
COPY rnacentral/portal/static/package.json /srv/rnacentral
RUN cd /srv/rnacentral && npm install --only=production && npm cache clean --force;

# Copy openssl.cnf
COPY openssl/openssl.cnf /etc/ssl/openssl.cnf

# Run entrypoint
COPY ./entrypoint-local.sh /
RUN chmod 744 /entrypoint-local.sh
ENTRYPOINT ["/entrypoint-local.sh"]
