FROM docker.elastic.co/elasticsearch/elasticsearch:7.16.2

RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip cron && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip

RUN pip3 install --no-cache-dir requests
RUN pip3 install --no-cache-dir psutil
RUN pip3 install --no-cache-dir elasticsearch==7.10.0

# copy system health files
COPY ./system_health/ /system_health/
COPY ./system_health/crontabs/crontab.es /etc/cron.d/crontab

RUN chmod 0644 /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab
RUN touch /var/log/cron_es.log

ENV TINI_SUBREAPER=""
CMD cron && /bin/tini -- /usr/local/bin/docker-entrypoint.sh eswrapper