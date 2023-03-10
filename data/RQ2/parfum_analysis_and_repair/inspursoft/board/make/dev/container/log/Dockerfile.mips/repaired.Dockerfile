FROM inspursoft/baseimage-mips:1.0

RUN yum install -y rsyslog crontabs && \
	rm /etc/rsyslog.d/* && rm /etc/rsyslog.conf && rm -rf /var/cache/yum

ADD make/dev/container/log/rsyslog.conf /etc/rsyslog.conf

# rotate logs weekly
# notes: file name cannot contain dot, or the script will not run
ADD make/dev/container/log/rotate.sh /etc/cron.weekly/rotate

# rsyslog configuration file for docker
ADD make/dev/container/log/rsyslog_docker.conf /etc/rsyslog.d/

VOLUME /var/log/board/

EXPOSE 514

CMD crond && rsyslogd -n
