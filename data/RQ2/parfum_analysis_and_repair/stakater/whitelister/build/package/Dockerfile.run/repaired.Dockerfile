FROM alpine:3.9
LABEL maintainer "Stakater Team"

RUN apk add --no-cache --update ca-certificates

COPY Whitelister /bin/Whitelister

ENTRYPOINT ["/bin/Whitelister"]
