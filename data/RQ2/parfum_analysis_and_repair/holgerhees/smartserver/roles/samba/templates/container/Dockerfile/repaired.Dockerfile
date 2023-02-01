FROM alpine:{{image_version}}

RUN apk add --no-cache --update samba-common-tools samba-client samba-server tzdata

ENTRYPOINT ["smbd", "--foreground", "--debuglevel=1", "--debug-stdout", "--no-process-group"]
