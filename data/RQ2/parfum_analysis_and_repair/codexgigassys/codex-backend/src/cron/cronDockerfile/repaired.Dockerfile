FROM busybox
# copied from https://hub.docker.com/r/lodatol/cron/~/dockerfile/
RUN mkdir -p /var/spool/cron/crontabs
CMD ntpd -p pool.ntp.org && echo "$CRON_ENTRY" | crontab - && crond -f