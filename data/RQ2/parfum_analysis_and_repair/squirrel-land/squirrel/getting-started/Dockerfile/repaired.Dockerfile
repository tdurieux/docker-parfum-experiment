FROM alpine:3.3

RUN apk update
RUN apk add --no-cache bash iperf

ADD squirrel-worker /bin/

ENTRYPOINT ["/bin/squirrel-worker"]
