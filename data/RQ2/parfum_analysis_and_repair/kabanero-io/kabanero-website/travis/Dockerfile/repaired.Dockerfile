# Use the official Ruby image as a parent image
FROM ruby:latest

# update the repository sources list
# and install dependencies
RUN apt-get update \
    && apt-get -y --no-install-recommends install maven \
    && apt-get -y --no-install-recommends install python3-requests && rm -rf /var/lib/apt/lists/*;

# install node for lint test dependencies
ENV NODE_VERSION=12.6.0
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

RUN npm install eslint --save-dev && npm cache clean --force;

RUN curl -fsSL https://clis.cloud.ibm.com/install/linux | sh

COPY . .