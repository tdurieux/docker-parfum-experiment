FROM docker.io/library/busybox AS build
RUN rm -f /bin/paste
USER 1001
COPY --from=docker.io/library/busybox /bin/paste /test/