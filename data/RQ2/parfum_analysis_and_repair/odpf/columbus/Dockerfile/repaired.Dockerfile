FROM alpine:latest

COPY compass /usr/bin/compass
RUN apk update
RUN apk add --no-cache ca-certificates

CMD ["compass"]
