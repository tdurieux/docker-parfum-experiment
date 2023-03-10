FROM node:12-alpine

COPY . /jackett-sync
COPY ./entrypoint.sh /
COPY ./cron /etc/cron.d/

# RUN apk add cron

# RUN rc-service crond start && rc-update add crond

RUN chmod 0644 /etc/cron.d/cron
RUN crontab /etc/cron.d/cron

RUN touch /var/log/cron.log

WORKDIR /jackett-sync

RUN yarn install && yarn cache clean;

# ENTRYPOINT [ "/bin/sh", "/entrypoint.sh" ]
CMD crond & tail -f /var/log/cron.log
