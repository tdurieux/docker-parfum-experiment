FROM alpine:3.9
MAINTAINER "Stakater Team"

RUN apk add --no-cache --update ca-certificates

COPY Jamadar /bin/Jamadar

ENTRYPOINT ["/bin/Jamadar"]
