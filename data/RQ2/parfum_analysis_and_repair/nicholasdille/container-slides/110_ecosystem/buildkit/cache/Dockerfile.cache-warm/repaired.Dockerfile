#syntax=docker/dockerfile:1.2
FROM ubuntu
RUN --mount=type=cache,target=/tmp/cache \
    touch /tmp/cache/foo.bar