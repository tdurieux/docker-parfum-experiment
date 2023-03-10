FROM alpine:latest

COPY tests/dockerfiles/alpine-entrypoint/entrypoint-stderr.sh /entrypoint

# non-root user required to enable the docker executor's file ownership change
USER 1000:1000

ENTRYPOINT ["/entrypoint"]