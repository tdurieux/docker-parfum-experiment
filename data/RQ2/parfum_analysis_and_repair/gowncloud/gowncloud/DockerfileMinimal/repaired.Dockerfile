FROM scratch

ADD ./dist/gowncloud /gowncloud

EXPOSE 80

VOLUME ["/gowncloud-data"]

ENTRYPOINT ["/gowncloud", "-b", ":80"]