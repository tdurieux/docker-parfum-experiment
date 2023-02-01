FROM alpine
RUN apk --no-cache add ca-certificates
RUN apk update && apk add --no-cache rsync
COPY irsync /
WORKDIR /
ENTRYPOINT ["/irsync"]