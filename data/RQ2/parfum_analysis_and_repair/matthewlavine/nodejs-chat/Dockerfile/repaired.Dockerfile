#
# matthewlavine.net dockerfile
#


# Pull base image
FROM node
MAINTAINER Matthew Lavine <matt@matthewlavine.net>

COPY . /src

RUN cd /src; npm install && npm cache clean --force;

EXPOSE 3000

CMD ["node", "/src/app.js"]