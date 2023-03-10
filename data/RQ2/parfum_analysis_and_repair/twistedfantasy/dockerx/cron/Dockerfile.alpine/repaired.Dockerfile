ARG IMAGE
FROM $IMAGE
LABEL maintainer="Denis Sventitsky <denis.sventitsky@gmail.com> / Twisted Fantasy <twisteeed.fantasy@gmail.com>"

ENV CRON_PATH=/etc/crontabs/root
ADD cron/crontab-alpine $CRON_PATH

# FIXME: do we need to install all this stuff???
RUN apk update && apk add --no-cache dcron curl wget rsync ca-certificates && rm -rf /var/cache/apk/*
RUN apk add --no-cache dcron
RUN apk update && apk add --no-cache apk-cron curl wget rsync ca-certificates && rm -rf /var/cache/apk/*

CMD crond -f -L -
