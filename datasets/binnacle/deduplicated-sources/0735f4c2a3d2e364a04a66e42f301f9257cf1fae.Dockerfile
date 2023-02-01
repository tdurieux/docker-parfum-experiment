FROM sysdig/sysdig:0.26.1

#
# Install node.js (v10)
#
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10.5.0
ENV NVM_VERSION 0.31.2

RUN curl -s -o- https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash

RUN /bin/bash -c "source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default"

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

#
# Setup environment
#
ENV NODE_ENV production
ENV SYSDIG_SERVER_PORT 3000
ENV SYSDIG_PATH /usr/bin
ENV SYSDIG_SERVER_HOSTNAME 0.0.0.0

#
# Add Sysdig Inspect
#
ADD dist /usr/bin/sysdig-inspect
WORKDIR /usr/bin/sysdig-inspect

#
# Configure health check
#
HEALTHCHECK --interval=1m --timeout=20s \
  CMD curl -f http://localhost:3000/health || exit 1

#
# Expose Sysdig Inspect UI endpoint
#
EXPOSE 3000

#
# Start it!
#
CMD ["npx", "forever", "main.js"]
