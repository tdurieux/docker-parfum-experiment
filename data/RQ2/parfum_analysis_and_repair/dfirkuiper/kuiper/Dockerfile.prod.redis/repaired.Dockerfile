FROM redis:latest

RUN apt update && apt install --no-install-recommends -y python3 python3-pip cron && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir redis
RUN pip install --no-cache-dir requests
RUN pip install --no-cache-dir psutil

COPY ./system_health/ /system_health/


COPY ./system_health/crontabs/crontab.redis /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab
RUN touch /var/log/cron_redis.log


CMD cron && docker-entrypoint.sh redis-server