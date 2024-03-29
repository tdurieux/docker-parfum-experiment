FROM python:3.7-alpine AS builder

RUN addgroup -S zulipgr \
    && adduser -S zulip -G zulipgr \
    && apk add --no-cache git ca-certificates gcc musl-dev \
                          libffi-dev openssl-dev libxml2-dev \
                          libxslt-dev cargo
USER zulip
WORKDIR /home/zulip

ARG SOURCE=pypi
ARG GIT_URL=https://github.com/zulip/zulip-terminal.git@main

RUN set -ex; python3 -m venv zt_venv \
    && source zt_venv/bin/activate \
    && if [ "$SOURCE" = "pypi" ] ; \
        then \
        pip3 --disable-pip-version-check --no-cache-dir install zulip-term; \
       fi \
    && if [ "$SOURCE" = "git" ] ; \
        then \
        pip3 --disable-pip-version-check --no-cache-dir install git+$GIT_URL; \
       fi \
    && rm -rf /home/zulip/.cache

FROM python:3.7-alpine

RUN addgroup -S zulipgr \
    && adduser -S zulip -G zulipgr \
    && apk add --no-cache ca-certificates libffi openssl libxml2 libxslt \
    && rm -rf /var/cache/apk/*

COPY --from=builder --chown=zulip:zulipgr /home/zulip /home/zulip
USER zulip
WORKDIR /home/zulip
ENTRYPOINT ["/home/zulip/zt_venv/bin/zulip-term"]
CMD ["--config-file", "/.zulip/zuliprc"]
