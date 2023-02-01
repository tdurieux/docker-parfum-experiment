FROM ubuntu:20.04

MAINTAINER SDF Ops Team <ops@stellar.org>

ADD . /app/src
WORKDIR /app/src

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    gpg curl ca-certificates git apt-transport-https && \
    curl -f -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --batch --dearmor >/etc/apt/trusted.gpg.d/nodesource.gpg && \
    echo "deb https://deb.nodesource.com/node_16.x focal main" | tee /etc/apt/sources.list.d/nodesource.list && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --batch --dearmor >/etc/apt/trusted.gpg.d/yarnpkg.gpg && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y nodejs yarn && \
    yarn install && /app/src/node_modules/gulp/bin/gulp.js build && yarn cache clean; && rm -rf /var/lib/apt/lists/*;

ENV PORT=80 UPDATE_DATA=false
EXPOSE 80

RUN node_modules/typescript/bin/tsc

ENTRYPOINT ["/usr/bin/node"]
CMD ["./backend/app.js"]
