FROM busybox:1.33.1
HEALTHCHECK CMD /bin/healthcheck

FROM alpine:3.13
HEALTHCHECK CMD /bin/healthcheck
USER mike
CMD ./app