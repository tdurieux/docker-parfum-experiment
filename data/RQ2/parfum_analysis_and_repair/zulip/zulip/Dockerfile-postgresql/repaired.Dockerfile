# This is a multiarch Dockerfile.  See https://docs.docker.com/desktop/multi-arch/
#
# To set up the first time:
#     docker buildx create --name multiarch --use
#
# To build:
#     docker buildx build --platform linux/amd64,linux/arm64 \
#       -f ./Dockerfile-postgresql -t zulip/zulip-postgresql:14 --push .

# Currently the PostgreSQL images do not support automatic upgrading of
# the on-disk data in volumes. So the base image can not currently be upgraded
# without users needing a manual pgdump and restore.

# https://hub.docker.com/r/groonga/pgroonga/tags
ARG PGROONGA_VERSION=latest
ARG POSTGRESQL_VERSION=14
FROM groonga/pgroonga:$PGROONGA_VERSION-alpine-$POSTGRESQL_VERSION-slim

# Install hunspell, Zulip stop words, and run Zulip database
# init.