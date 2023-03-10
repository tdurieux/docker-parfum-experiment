FROM iron/ruby-bundle

RUN echo '@community http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories
RUN apk update && apk upgrade

RUN apk add --no-cache docker@community
# puts file in /etc/runlevels/...
RUN rc-update add docker default

CMD ["/sbin/rc", "default"]

# Clean APK cache
RUN rm -rf /var/cache/apk/*
