ARG FROM_IMAGE=baserow/baserow:1.10.2
# This is pinned as version pinning is done by the CI setting FROM_IMAGE.
# hadolint ignore=DL3006
FROM $FROM_IMAGE as image_base

RUN apt-get remove -y postgresql postgresql-contrib redis-server

ENV DATA_DIR=/baserow/data
# We have to build the data dir in the docker image as Caddy does not allow it in their
# runtime filesystem. We chown to their www-data user's uid and gid at the end.
RUN mkdir -p "$DATA_DIR" && \
    chown -R 9999:9999 "$DATA_DIR"

COPY deploy/heroku/heroku_env.sh /baserow/supervisor/env/heroku_env.sh

ENTRYPOINT []
CMD []
