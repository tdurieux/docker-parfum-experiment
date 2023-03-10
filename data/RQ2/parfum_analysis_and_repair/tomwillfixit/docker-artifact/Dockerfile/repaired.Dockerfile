FROM alpine:3.11

RUN --mount=type=cache,id=apk,target=/var/cache/apk ln -vs /var/cache/apk /etc/apk/cache && \
	apk add --no-cache --update \
        python3 curl jq bash

COPY --from=tomwillfixit/docker-artifact:latest docker-artifact.sh /docker-artifact

# Download single file from big image using docker artifact

RUN /docker-artifact get DockerDesktop.png tomwillfixit/big-image:latest

