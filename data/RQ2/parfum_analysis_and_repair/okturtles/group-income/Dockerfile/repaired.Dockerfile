# FROM alpine
# https://github.com/cypress-io/cypress-docker-images
FROM cypress/base:12.6.0

ARG TIMEZONE
ENV TERM=xterm LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Old Alpine stuff
# https://github.com/nodejs/docker-node/issues/588
# not sure if it's paxctl -cm or paxctl -cM
#RUN apk -U upgrade --available \
#  && apk add \
#    ca-certificates openssl wget file nano tzdata htop git cmake build-base sqlite \
#    paxctl python2 nodejs npm xvfb xvfb-run \
#  && update-ca-certificates \
#  && paxctl -cm $(which node) \
#  && paxctl -cm $(which python2) \
#  && ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
#  && echo "${TIMEZONE}" > /etc/timezone \
#  && rm -f /var/cache/apk/*

RUN apt-get install --no-install-recommends -y tzdata ca-certificates \
  && update-ca-certificates \
  && ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo "${TIMEZONE}" > /etc/timezone && rm -rf /var/lib/apt/lists/*;

RUN npm i -g npm@latest \
  && npm i -g grunt-cli node-gyp \
  && ln -s /opt/test/cypress/cache /root/.cache && npm cache clean --force;

VOLUME /opt
WORKDIR /opt
CMD grunt dev
