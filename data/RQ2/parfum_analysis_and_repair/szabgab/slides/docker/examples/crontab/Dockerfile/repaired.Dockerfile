FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y cron && rm -rf /var/lib/apt/lists/*;

COPY crontab.txt /opt
RUN crontab /opt/crontab.txt

CMD ["cron", "-f"]
