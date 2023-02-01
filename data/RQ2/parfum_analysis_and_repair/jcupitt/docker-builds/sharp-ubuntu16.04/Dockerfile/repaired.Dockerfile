FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install --no-install-recommends -y \
    curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/src

# install node8 via the official PPA ... the nodejs that comes with
# ubuntu16.04 is 4.x and is no longer supported
RUN curl -f -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh \
    && bash ./nodesource_setup.sh \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# and now sharp should go on with just npm
RUN npm install sharp && npm cache clean --force;
