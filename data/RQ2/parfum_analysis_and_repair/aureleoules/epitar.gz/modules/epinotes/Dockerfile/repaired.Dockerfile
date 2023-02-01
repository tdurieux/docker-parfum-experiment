FROM alpine
RUN apk update && apk add --no-cache wget bash curl
WORKDIR /output

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
