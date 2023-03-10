FROM alpine:3.15

RUN apk add --no-cache git
WORKDIR /usr/bin/
COPY trufflehog .

ENTRYPOINT ["/usr/bin/trufflehog"]