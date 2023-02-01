FROM node:alpine
LABEL maintainer="Bjornskjald <github@bjorn.ml>"

RUN npm install --only=production -g miscord-beta

VOLUME ["/config"]

ENTRYPOINT [ "miscord-beta" ]
