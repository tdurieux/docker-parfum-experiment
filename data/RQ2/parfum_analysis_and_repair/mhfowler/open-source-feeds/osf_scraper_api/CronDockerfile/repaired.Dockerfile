FROM ubuntu:14.04

# install cron
RUN apt-get update && apt-get -y --no-install-recommends install cron curl && rm -rf /var/lib/apt/lists/*;

# Add crontab file
ADD devops/build/crontab /srv/crontab
RUN crontab /srv/crontab

# make log dir
RUN mkdir /srv/log

# copy entrypoint
COPY devops/build/cron-entrypoint.sh /srv/cron-entrypoint.sh
RUN chmod -v +x /srv/cron-entrypoint.sh

# start cron
CMD ["/srv/cron-entrypoint.sh"]