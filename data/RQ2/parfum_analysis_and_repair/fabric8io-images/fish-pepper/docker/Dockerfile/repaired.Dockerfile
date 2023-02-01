FROM node:lts

ENV FISH_PEPPER_VERSION 0.6.1

RUN apt-get update \
 && apt-get -y --no-install-recommends install make git libssl-dev gcc \
 && npm config set unsafe-perm true \
 && npm -g install fish-pepper@${FISH_PEPPER_VERSION} \
 && mkdir /fp \
 && rm -rf /var/lib/apt/lists/* && npm cache clean --force;

VOLUME /fp
WORKDIR /fp

ENTRYPOINT [ "fish-pepper" ]
