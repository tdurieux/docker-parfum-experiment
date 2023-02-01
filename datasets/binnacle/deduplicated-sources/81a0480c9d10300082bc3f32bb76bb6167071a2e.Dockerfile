FROM alpine:latest
MAINTAINER chungsub.kim@purpleworks.co.kr

RUN apk add --update ca-certificates
ADD bin/delibird_server /delibird_server
EXPOSE 9000

ENTRYPOINT ["/delibird_server"]
