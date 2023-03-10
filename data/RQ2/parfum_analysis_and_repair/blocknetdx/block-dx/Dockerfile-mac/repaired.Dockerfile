FROM ubuntu:18.04

ARG PLATFORM="mac"

# Update packages & install native dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     curl gnupg build-essential ca-certificates \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

 # Install node js
RUN apt-get update \
  && curl -f -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -y --no-install-recommends \
      nodejs \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create app directory
RUN mkdir -p /opt/block-dx/dist-native

WORKDIR /opt/block-dx/
VOLUME /opt/block-dx/dist-native

# Install app dependencies
COPY package.json /opt/block-dx/
RUN npm install --no-audit && npm cache clean --force;

# Bundle app source
COPY . /opt/block-dx/

ARG GIT_BRANCH=""
RUN if [ ! -z "$GIT_BRANCH" ]; then echo GIT_BRANCH=$GIT_BRANCH > /opt/block-dx/electron-builder.env; fi

ENTRYPOINT ["npm"]
CMD ["run", "build-native-mac"]
