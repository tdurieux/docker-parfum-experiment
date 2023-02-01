## We do not have any dependency on Sebak itself and should not
FROM alpine:latest

RUN apk --no-cache add bash curl jq

## Copy the full directory