FROM alpine
LABEL maintainer="dev@jamesturk.net"

ADD forever.sh /
ENTRYPOINT ["/forever.sh"]