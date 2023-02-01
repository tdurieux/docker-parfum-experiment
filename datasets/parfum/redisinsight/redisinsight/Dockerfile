FROM node:14.17-alpine as front
RUN apk update
RUN apk add --no-cache --virtual .gyp \
        python \
        make \
        g++
WORKDIR /usr/src/app
COPY package.json yarn.lock babel.config.js tsconfig.json ./
COPY configs ./configs
COPY scripts ./scripts
COPY redisinsight ./redisinsight
RUN SKIP_POSTINSTALL=1 yarn install
RUN yarn --cwd redisinsight/api
ARG SERVER_TLS_CERT
ARG SERVER_TLS_KEY
ENV SERVER_TLS_CERT=${SERVER_TLS_CERT}
ENV SERVER_TLS_KEY=${SERVER_TLS_KEY}
RUN yarn build:web
RUN yarn build:statics

FROM node:14.17-alpine as back
WORKDIR /usr/src/app
COPY redisinsight/api/package.json redisinsight/api/yarn.lock ./
RUN yarn install
COPY redisinsight/api ./
COPY --from=front /usr/src/app/redisinsight/api/static ./static
COPY --from=front /usr/src/app/redisinsight/api/defaults ./defaults
RUN yarn run build:prod

FROM node:14.17-slim
# Set up mDNS functionality, to play well with Redis Enterprise
# clusters on the network.
RUN set -ex \
 && DEPS="avahi-daemon libnss-mdns" \
 && apt-get update && apt-get install -y --no-install-recommends $DEPS \
 # Disable nss-mdns's two-label limit heuristic so that host names
 # with multiple labels can be resolved.
 # E.g. redis-12000.rediscluster.local, which has 3 labels.
 # (https://github.com/lathiat/nss-mdns#etcmdnsallow)
 && echo '*' > /etc/mdns.allow \
 # Configure NSSwitch to use the mdns4 plugin so mdns.allow is respected
 && sed -i "s/hosts:.*/hosts:          files mdns4 dns/g" /etc/nsswitch.conf \
 # We run a `avahi-daemon` without `dbus` so that we can start it as a
 # non-root user. `dbus` requires root permissions to start. And
 # anyway, there's a way to run `avahi-daemon` without `dbus` so why
 # shouldn't we use it.  https://linux.die.net/man/5/avahi-daemon.conf
 && printf "[server]\nenable-dbus=no\n" >> /etc/avahi/avahi-daemon.conf \
 && chmod 777 /etc/avahi/avahi-daemon.conf \
 # We create the directory because when the first time `avahi-daemon`
 # is run, the directory doesn't exist and the `avahi-daemon` must have
 # permissions to create the directory under `/var`.
 && mkdir -p /var/run/avahi-daemon \
 # Change the permissions of the directories avahi will use.
 && chown avahi:avahi /var/run/avahi-daemon \
 && chmod 777 /var/run/avahi-daemon

RUN apt-get install net-tools
RUN apt-get install -y dbus-x11 gnome-keyring libsecret-1-0
RUN dbus-uuidgen > /var/lib/dbus/machine-id

ARG NODE_ENV=production
ARG SERVER_TLS_CERT
ARG SERVER_TLS_KEY
ENV SERVER_TLS_CERT=${SERVER_TLS_CERT}
ENV SERVER_TLS_KEY=${SERVER_TLS_KEY}
ENV NODE_ENV=${NODE_ENV}
ENV SERVER_STATIC_CONTENT=true
ENV BUILD_TYPE='DOCKER_ON_PREMISE'
WORKDIR /usr/src/app
COPY --from=back /usr/src/app/dist ./redisinsight/api/dist
COPY --from=front /usr/src/app/redisinsight/ui/dist ./redisinsight/ui/dist

# Build BE prod dependencies here to build native modules
COPY redisinsight/api/package.json redisinsight/api/yarn.lock ./redisinsight/api/
RUN yarn --cwd ./redisinsight/api install --production
COPY redisinsight/api/.yarnclean.prod ./redisinsight/api/.yarnclean
RUN yarn --cwd ./redisinsight/api autoclean --force

COPY ./docker-entry.sh ./
RUN chmod +x docker-entry.sh

EXPOSE 5000

ENTRYPOINT ["./docker-entry.sh", "node", "redisinsight/api/dist/src/main"]
