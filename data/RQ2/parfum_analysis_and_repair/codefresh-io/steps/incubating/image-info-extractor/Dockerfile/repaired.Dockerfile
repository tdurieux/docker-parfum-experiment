FROM alpine:3.13.6

RUN apk update && apk add --no-cache skopeo=1.2.1-r0 jq=1.6-r1
