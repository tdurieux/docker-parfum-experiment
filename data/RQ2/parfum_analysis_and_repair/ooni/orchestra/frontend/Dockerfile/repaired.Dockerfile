# Best practices for development, and not for a production deployment
# from https://nodejs.org/en/docs/guides/nodejs-docker-webapp/

# Build: run ooni-sysadmin.git/scripts/docker-build from this directory

FROM node:carbon

# BEGIN root
USER root
COPY . /usr/src/app
RUN set -ex \
    && chown -R node:node /usr/src/app \
    && :
# END root

USER node
WORKDIR /usr/src/app

# .cache removal leads to two times smaller image and
RUN set -ex \
    && yarn install --frozen-lockfile \
    && rm -rf /home/node/.cache && yarn cache clean;

EXPOSE 3000

CMD [ "/usr/src/app/docker-cmd.sh" ]
