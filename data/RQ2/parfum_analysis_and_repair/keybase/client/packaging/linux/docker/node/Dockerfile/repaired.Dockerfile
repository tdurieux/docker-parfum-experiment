ARG BASE_IMAGE=keybaseio/client:latest
FROM $BASE_IMAGE AS base

FROM node:12.16.2-buster
LABEL maintainer="Keybase <admin@keybase.io>"

RUN apt-get update \
    && apt-get install --no-install-recommends -y gnupg2 procps ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
COPY packaging/linux/docker/tini_key.asc /tini_key.asc
RUN gpg --batch --import /tini_key.asc \
    && rm /tini_key.asc \
    && gpg --batch --verify /tini.asc /tini \
    && chmod +x /tini && rm /tini.asc

ENV GOSU_VERSION 1.11
ADD https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 /usr/local/bin/gosu
ADD https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc /usr/local/bin/gosu.asc
COPY packaging/linux/docker/gosu_key.asc /gosu_key.asc
RUN gpg --batch --import /gosu_key.asc \
    && rm /gosu_key.asc \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && chmod +x /usr/local/bin/gosu && rm /usr/local/bin/gosu.asc

COPY --from=base /usr/bin/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

RUN usermod -l keybase -d /home/keybase -m node \
    && groupmod -n keybase node
VOLUME [ "/home/keybase/.config/keybase", "/home/keybase/.cache/keybase" ]

COPY --from=base /usr/bin/keybase /usr/bin/keybase
COPY --from=base /usr/bin/keybase.sig /usr/bin/keybase.sig
COPY --from=base /usr/bin/kbfsfuse /usr/bin/kbfsfuse
COPY --from=base /usr/bin/kbfsfuse.sig /usr/bin/kbfsfuse.sig
COPY --from=base /usr/bin/git-remote-keybase /usr/bin/git-remote-keybase
COPY --from=base /usr/bin/git-remote-keybase.sig /usr/bin/git-remote-keybase.sig

ENTRYPOINT ["/tini", "--", "entrypoint.sh"]
