FROM node

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends zip && \
    rm -r /var/lib/apt/lists/*

ARG GOSU_VERSION=1.9
RUN curl -f -Lo /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" && \
    curl -f -Lo /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && rm -rf -d

RUN npm install -g gulp && npm cache clean --force;

ENV USER_ID=1000 GROUP_ID=1000

CMD groupadd user -g ${GROUP_ID} -o && \
    useradd -u ${USER_ID} -o --create-home --home-dir /home/user -g user user && \
    cd /potree && \
    if [ ! -d "node_modules/gulp" ]; then \
      gosu user npm install --save-dev; \
    fi && \
    gosu user gulp build && \
    gosu user rm potree.zip; \
    gosu user zip -r potree.zip build libs LICENSE -x '*Cesium*'