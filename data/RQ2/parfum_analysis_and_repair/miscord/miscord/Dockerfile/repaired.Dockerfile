FROM node:alpine
LABEL maintainer="ptrcnull <github@ptrcnull.me>"

RUN npm install --only=production -g miscord && npm cache clean --force;

VOLUME ["/config"]

ENTRYPOINT [ "miscord" ]
