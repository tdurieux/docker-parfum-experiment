FROM alpine:edge
MAINTAINER Rémi Alvergnat <toilal.dev@gmail.com>

RUN apk add --no-cache --update openssh shadow && rm -rf /var/cache/apk/*

RUN addgroup -S {{ stealthbox.ssh.login }} && adduser -S {{ stealthbox.ssh.login }} -G {{ stealthbox.ssh.login }} -s /bin/sh

VOLUME /etc/ssh

#fixuid-manual-entrypoint
ADD /entrypoint.sh /
CMD /entrypoint.sh
