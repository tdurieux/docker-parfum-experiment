FROM ubuntu:14.04

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install base dependencies
RUN apt-get update && apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        python \
        rsync \
    && rm -rf /var/lib/apt/lists/*

# Install nvm with node and npm
# http://stackoverflow.com/questions/25899912/install-nvm-in-docker
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8
RUN mkdir -p ${NVM_DIR} \
    && curl -f -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
ENV PATH      $NVM_BIN:$PATH

# Go ahead and install nodemon for convenience while developing
RUN source $NVM_DIR/nvm.sh

###########################
# App-specific stuff

# mongo uses kerberos
RUN apt-get update && apt-get install --no-install-recommends -y libkrb5-dev && rm -rf /var/lib/apt/lists/*;

# install jq for json processing
RUN apt-get -y --no-install-recommends install jq && rm -rf /var/lib/apt/lists/*;

# Install NPM dependencies. Do this first so that if package.json hasn't
# changed we don't have to re-run npm install during `docker build`
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
WORKDIR /app
RUN source $NVM_DIR/nvm.sh; npm install && npm cache clean --force;
# Copy the app
COPY ["index.js", ".eslintrc", ".eslintignore", ".babelrc", "knexfile.js", "/app/"]
COPY ["fetch.js", "/app/"]
COPY lib /app/lib/
COPY certs /app/certs/
COPY test /app/test/
COPY sources /app/sources/
COPY adapters /app/adapters/
COPY migrations /app/migrations/
COPY index.sh /app/
COPY index.adapter.sh /app/

#############################
# entrypoint
#
RUN source $NVM_DIR/nvm.sh
ADD .build_scripts/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]