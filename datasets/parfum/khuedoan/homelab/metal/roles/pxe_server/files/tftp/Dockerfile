FROM alpine:20220316

RUN apk add busybox tftp-hpa

ENTRYPOINT [ "/bin/sh", "-c" ]

CMD [ "busybox syslogd -n -O /dev/stdout & in.tftpd -vvv --foreground --secure /var/lib/tftpboot" ]
