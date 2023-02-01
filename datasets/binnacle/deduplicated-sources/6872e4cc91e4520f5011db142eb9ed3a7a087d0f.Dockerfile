FROM busybox:ubuntu-14.04
MAINTAINER Johannes Wuerbach (johannes.wuerbach@googlemail.com)

ENV NEW_RELIC_LICENSE_KEY YOUR_LICENSE_KEY
ENV CUSTOM_HOSTNAME CUSTOM_HOSTNAME
ENV LOG_LEVEL info
ENV NEW_RELIC_VERSION 2.3.0.132

ADD https://download.newrelic.com/server_monitor/release/newrelic-sysmond-${NEW_RELIC_VERSION}-linux.tar.gz /newrelic-sysmond.tar.gz
RUN tar xvfz /newrelic-sysmond.tar.gz && \
  rm /newrelic-sysmond.tar.gz

WORKDIR /newrelic-sysmond-${NEW_RELIC_VERSION}-linux
RUN mv ./nrsysmond.cfg /etc/ && \
  mv ./scripts/nrsysmond-config /bin && \
  mv ./daemon/nrsysmond.x64 /bin/nrsysmond

CMD nrsysmond-config --set license_key=$NEW_RELIC_LICENSE_KEY && \
  nrsysmond -c /etc/nrsysmond.cfg -n $CUSTOM_HOSTNAME -d $LOG_LEVEL -l /dev/stdout -f
