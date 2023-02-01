FROM alpine:20220328

RUN apk add --no-cache tftp-hpa

CMD [ "in.tftpd", "--foreground", "--secure", "/var/lib/tftpboot" ]
