FROM alpine

RUN apk update && apk add --no-cache curl

RUN apk --purge del apk-tools curl
