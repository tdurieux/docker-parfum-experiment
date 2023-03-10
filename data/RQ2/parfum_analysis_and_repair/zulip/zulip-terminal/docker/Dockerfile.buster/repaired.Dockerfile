FROM python:3.7-buster AS builder

RUN useradd --user-group --create-home zulip
USER zulip
WORKDIR /home/zulip

ARG SOURCE=pypi
ARG GIT_URL=https://github.com/zulip/zulip-terminal.git@main

RUN set -ex; python3 -m venv zt_venv \
    && . zt_venv/bin/activate \
    && if [ "$SOURCE" = "pypi" ] ; \
        then \
        pip3 --disable-pip-version-check --no-cache-dir install zulip-term; \
       fi \
    && if [ "$SOURCE" = "git" ] ; \
        then \
        pip3 --disable-pip-version-check --no-cache-dir install git+$GIT_URL; \
       fi \
    && rm -rf /home/zulip/.cache

FROM python:3.7-slim-buster

RUN useradd --user-group --create-home zulip
COPY --from=builder --chown=zulip:zulip /home/zulip /home/zulip
USER zulip
WORKDIR /home/zulip
ENTRYPOINT ["/home/zulip/zt_venv/bin/zulip-term"]
CMD ["--config-file", "/.zulip/zuliprc"]
