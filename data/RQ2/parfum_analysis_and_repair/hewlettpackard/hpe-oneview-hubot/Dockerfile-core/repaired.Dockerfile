# Docker best practices/commands:
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/

FROM alpine:3.8

RUN adduser -Ds /bin/bash docker

###############################################################################
USER docker
COPY . /home/docker/hubot-core-org/
RUN mkdir -p /home/docker/hubot/node_modules
RUN chmod 777 /home/docker/hubot/
RUN chmod 777 /home/docker/hubot/node_modules
WORKDIR /home/docker/hubot

###############################################################################
USER root

#http://askubuntu.com/questions/506158/unable-to-initialize-frontend-dialog-when-using-ssh
ENV DEBIAN_FRONTEND=noninteractive

ARG http_proxy
ARG https_proxy

# Steps from:
# https://github.com/HewlettPackard/hpe-oneview-hubot/wiki/Getting-Started

# 1. Clone repo

# 2. Install node.js + npm (etc.)
RUN apk --no-cache add \
    curl                                \
    libcurl                             \
    sudo                                \
    bash                                \
    php5-curl
#RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
#RUN apk add --no-cache aptitude
#RUN aptitude install -y
RUN apk --no-cache add --update \
    jq                          \
    nodejs npm

RUN node -v

RUN npm config set proxy $http_proxy
RUN npm config set http-proxy $http_proxy
RUN npm config set https-proxy $http_proxy


# 3. Install Hubot

RUN npm install -g yo generator-hubot && npm cache clean --force;

###############################################################################
USER docker

RUN npm config set proxy $http_proxy
RUN npm config set http-proxy $http_proxy
RUN npm config set https-proxy $http_proxy


RUN echo "n" | yo hubot --defaults --name="bot" --adapter=slack

###############################################################################
USER root

# Avoid warnings for deprecated dependencies:
RUN npm install -g minimatch@^3.0.4; npm cache clean --force; \
    npm install -g graceful-fs@^4.2.2;

RUN npm install gulp; npm cache clean --force; \
    npm install gulp-task-listing@^1.1.0;

###############################################################################
USER docker


RUN npm install hubot@3.x                \
    amqp@^0.2.7                          \
    d3@^5.9.7                            \
    jsdom@^15.1.1                        \
    svg2png@^4.1.1                       \
    fuzzyset.js@0.0.8                    \
    compromise@^11.14.2                  \
    request@^2.88.0                      \
    request-promise@^4.2.4; npm cache clean --force;


RUN npm install del@^5.0.0; npm cache clean --force;

###############################################################################
USER root

# 4. Install gulp (etc.)

WORKDIR /home/docker/hubot-core-org

# Avoid warnings for deprecated dependencies:
RUN npm install -g minimatch@^3.0.4; npm cache clean --force; \
    npm install -g graceful-fs@^4.2.2;

RUN npm install -g gulp; npm cache clean --force; \
    npm install; \
    npm install gulp; \
    npm install gulp-task-listing@^1.1.0; \
    npm install fancy-log@^1.3.3

RUN npm install hubot@3.x                \
    amqp@^0.2.7                          \
    d3@^5.9.7                            \
    jsdom@^15.1.1                        \
    svg2png@^4.1.1                       \
    fuzzyset.js@0.0.8                    \
    compromise@^11.14.2                  \
    request@^2.88.0                      \
    request-promise@^4.2.4               \
    del@^5.0.0; npm cache clean --force;


# 5. Copy config file
# 6. Update IP (docker_run.sh handles this)
# 7. Run gulp watch (docker_go.sh handles this, called by docker_run.sh)
# 8. Run bin/hubot (docker_go.sh handles this, called by docker_run.sh)
# 9. Test your bot (instructions presented by docker_go.sh)

COPY docker_entry.sh /usr/local/bin/
COPY docker_go.sh /go.sh

ENTRYPOINT ["sh", "/usr/local/bin/docker_entry.sh"]
