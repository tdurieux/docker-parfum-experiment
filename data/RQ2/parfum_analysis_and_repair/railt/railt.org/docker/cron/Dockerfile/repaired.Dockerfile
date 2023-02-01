FROM railt_org:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -my wget gnupg && rm -rf /var/lib/apt/lists/*;

# Install dotdeb repo
RUN echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list \
    && curl -f -sS https://www.dotdeb.org/dotdeb.gpg | apt-key add - \
    && apt-get update

# Install required libs
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        cron \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

#####################################
# Crontab
#####################################

COPY ./crontab /etc/cron.d
RUN chmod 0644 /etc/cron.d

RUN mkfifo --mode 0666 /var/log/cron.log

CMD ["/bin/bash", "-c", "cron && tail -f /var/log/cron.log"]
