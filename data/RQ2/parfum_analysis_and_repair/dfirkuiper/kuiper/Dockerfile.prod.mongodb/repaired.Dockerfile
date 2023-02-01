FROM mongo:4.2


RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip cron && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip

RUN pip3 install --no-cache-dir requests
RUN pip3 install --no-cache-dir psutil
RUN pip3 install --no-cache-dir pymongo==2.8

COPY ./system_health/ /system_health/

COPY ./system_health/crontabs/crontab.mongodb /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab
RUN touch /var/log/cron_mongodb.log


CMD cron && docker-entrypoint.sh mongod