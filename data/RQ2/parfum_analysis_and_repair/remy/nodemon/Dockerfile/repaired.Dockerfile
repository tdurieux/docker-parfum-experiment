#
# Ubuntu Node.js Dockerfile
#
# https://github.com/dockerfile/ubuntu/blob/master/Dockerfile
# https://docs.docker.com/examples/nodejs_web_app/
#

# Pull base image.
FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y curl locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Install Node.js
RUN curl -f --silent --location https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --no-install-recommends --yes nodejs build-essential && rm -rf /var/lib/apt/lists/*;

# Install app dependencies
RUN npm install -g npx && npm cache clean --force;

# Bundle app source
# Trouble with COPY http://stackoverflow.com/a/30405787/2926832
# COPY . /src

WORKDIR /src


# Binds to port 8080
# EXPOSE  8080

#  Defines your runtime(define default command)
# These commands unlike RUN (they are carried out in the construction of the container) are run when the container
#CMD ["node", "/src/http.js"]
