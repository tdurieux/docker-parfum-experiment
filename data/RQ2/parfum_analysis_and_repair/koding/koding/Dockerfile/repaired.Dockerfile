FROM koding/base
MAINTAINER Sonmez Kartal <sonmez@koding.com>

ADD . /opt/koding
WORKDIR /opt/koding

ENV KODING_VERSION=master

RUN npm install --unsafe-perm && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --version $KODING_VERSION && \
    go/build.sh && \
    make -C client dist && \
    rm -rfv generated && \
    echo $KODING_VERSION > VERSION && npm cache clean --force;

ENTRYPOINT ["scripts/bootstrap-container"]
