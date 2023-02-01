FROM alpine:latest
RUN apk update && apk add --no-cache bash socat
ADD run.sh /usr/local/bin/run
ENV PORT=2375
EXPOSE $PORT
ENTRYPOINT ["/usr/local/bin/run"]
