FROM docker.io/library/busybox AS test
RUN rm -f /bin/nl
FROM docker.io/library/alpine AS final
COPY --from=docker.io/library/busybox /bin/nl /test/