FROM iron/ruby

RUN apk update && apk upgrade

RUN apk add --no-cache imagemagick

# Clean APK cache
RUN rm -rf /var/cache/apk/*
