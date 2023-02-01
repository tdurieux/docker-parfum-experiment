FROM mhart/alpine-node:8

MAINTAINER Datawire <dev@datawire.io>
LABEL VENDOR                   = "Datawire, Inc." \
      VENDOR_URL               = "https://datawire.io/"

WORKDIR /src
ADD . .
RUN npm install && npm cache clean --force;

EXPOSE 3000
CMD ["npm", "start"]
