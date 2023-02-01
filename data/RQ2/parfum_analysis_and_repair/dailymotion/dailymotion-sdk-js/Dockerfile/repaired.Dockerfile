FROM node:12.6.0

LABEL maintainer "Player Squad <squad-player@dailymotion.com>"

# Configure app basedir

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install yuicompressor deps

RUN apt-get update && apt-get install --no-install-recommends -y java-common default-jre-headless java-wrappers libjargs-java && rm -rf /var/lib/apt/lists/*;

# Install Node deps

COPY package.json /usr/src/app
COPY package-lock.json /usr/src/app
RUN npm install && npm cache clean --force;

# Copy app source

COPY src /usr/src/app/src

# Run!

RUN npm run build

# Package it for later deployment, files must end up at /usr/build/sdk_js.tar.gz
RUN mkdir -p /usr/build
RUN tar -czvf /usr/build/sdk_js.tar.gz \
  -C /usr/src/app/dist . && rm /usr/build/sdk_js.tar.gz
