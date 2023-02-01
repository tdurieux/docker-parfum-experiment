FROM ubuntu:20.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y cron && rm -rf /var/lib/apt/lists/*;

COPY crontab.txt /opt
RUN crontab /opt/crontab.txt

RUN touch /opt/jumanji.txt
CMD ["cron", "&&", "tail", "-f", "/opt/jumanji.txt"]
