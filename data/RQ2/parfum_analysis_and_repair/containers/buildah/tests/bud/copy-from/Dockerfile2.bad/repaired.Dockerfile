FROM busybox AS test
USER 1001
FROM busybox AS build
COPY --from=test /bin/cut /test/
COPY --from=build /bin/cp /test/
COPY --from=busybox /bin/paste /test/