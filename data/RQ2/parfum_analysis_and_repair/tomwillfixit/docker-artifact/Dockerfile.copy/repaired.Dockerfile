FROM alpine:3.11

RUN --mount=type=cache,id=apk,target=/var/cache/apk ln -vs /var/cache/apk /etc/apk/cache && \
	apk add --no-cache --update \
        curl jq bash

COPY --from=tomwillfixit/big-image:latest /tmp/DockerDesktop.png /DockerDesktop.png
