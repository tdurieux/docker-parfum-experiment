FROM arm64v8/alpine:3.8

RUN runDeps='curl rsyslog' \
 && apk add --no-cache --update $runDeps \
 && rm -rf /var/cache/apk/*

ADD make/release/container/log/rsyslog.conf /etc/rsyslog.conf

# rotate logs weekly
# notes: file name cannot contain dot, or the script will not run
ADD make/release/container/log/rotate.sh /etc/cron.weekly/rotate

# rsyslog configuration file for docker
ADD make/release/container/log/rsyslog_docker.conf /etc/rsyslog.d/

VOLUME /var/log/board/

EXPOSE 514

CMD crond && rsyslogd -n
