FROM alpine

ENTRYPOINT ["/usr/bin/cw"]

COPY cw /usr/bin/cw