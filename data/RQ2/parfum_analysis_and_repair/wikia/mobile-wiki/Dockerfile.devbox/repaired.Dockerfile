FROM node:12.19.0-alpine

WORKDIR /app

# mount app source
VOLUME ["/app"]

# install missing stuff
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing \
    python make g++ git bash curl gosu && \
#
# install npm globals
    # we are running npm install as root so we need to set unsafe-perm
    # in order to execute all npm postinstall scripts properly
    npm set unsafe-perm=true && \
    npm set progress=false && \
    npm install -g ember-cli && npm cache clean --force;

# 7001 is for debugging
EXPOSE 7001

ENTRYPOINT ["/app/wrapper.sh"]
CMD ["npm", "run", "dev"]
