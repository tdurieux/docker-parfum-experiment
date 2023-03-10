FROM ubuntu:latest

RUN apt-get update && apt-get -y --no-install-recommends install git build-essential libsqlite3-dev zlib1g-dev cron rsyslog wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade


# build tippecanoe
RUN mkdir -p /tmp/tippecanoe-src
RUN git clone https://github.com/mapbox/tippecanoe.git /tmp/tippecanoe-src
WORKDIR /tmp/tippecanoe-src
RUN make && make install

# clean up after build
WORKDIR /
RUN rm -rf /tmp/tippecanoe-src
RUN apt-get -y remove --purge build-essential && apt-get -y autoremove

# setup cron
COPY tile-processor/crontab /tmp/crontab
RUN touch /var/log/cron.log
RUN cat /tmp/crontab | crontab -
RUN crontab -l

# set up script
WORKDIR /app
COPY tile-processor/get-and-process-tiles.sh .

CMD rsyslogd -n && cron && tail -F /var/log/cron.log /var/log/syslog

