FROM alpine:3.7
RUN apk -U --no-cache add ca-certificates
COPY restify /usr/bin/
ENTRYPOINT ["/usr/bin/restify"]