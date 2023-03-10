#FROM google/nodejs
FROM node:0.10
MAINTAINER Christiaan Hees <christiaan@q42.nl>

ONBUILD WORKDIR /appsrc
ONBUILD COPY . /appsrc

 \
RUN curl -f https://install.meteor.com/ | sh && \
    meteor build ../app --directory --architecture os.linux.x86_64 && \
    rm -rf /appsrcONBUILD


# TODO rm meteor so it doesn't take space in the image?

ONBUILD WORKDIR /app/bundle

 \
RUN ( cd programs/server && npm install) && npm cache clean --force; ONBUILD
EXPOSE 8080
CMD []
ENV PORT 8080
# MONGO_SERVICE_HOST and MONGO_SERVICE_PORT are set by the Mongo service in Kubernetes:
#ENTRYPOINT MONGO_URL=mongodb://$MONGO_SERVICE_HOST:$MONGO_SERVICE_PORT /nodejs/bin/node main.js
ENTRYPOINT MONGO_URL=mongodb://$MONGO_SERVICE_HOST:$MONGO_SERVICE_PORT /usr/local/bin/node main.js
