FROM node:9.2.0
MAINTAINER Alex Simons "alexsimons9999@gmail.com"
USER root
VOLUME /app
WORKDIR /app

ENTRYPOINT ["npm", "install"]