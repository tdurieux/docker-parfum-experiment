FROM phusion/baseimage:0.9.15

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y spamassassin && rm -rf /var/lib/apt/lists/*;

RUN groupadd spamd && \
    useradd -g spamd -s /bin/false -d /var/log/spamassassin spamd && \
    mkdir -p /var/log/spamassassin && \
    chown -R spamd:spamd /var/log/spamassassin

ADD spamd.sh /tmp/spamd.sh
RUN mkdir /etc/service/spamd && \
    mv /tmp/spamd.sh /etc/service/spamd/run && \
    chmod +x /etc/service/spamd/run

ADD local.cf /etc/spamassassin/local.cf
ADD spam-learn /etc/cron.daily/spam-learn

CMD ["/sbin/my_init"]