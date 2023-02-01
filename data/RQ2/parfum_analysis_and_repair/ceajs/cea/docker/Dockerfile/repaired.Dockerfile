FROM ubuntu:latest
ENV TZ="Asia/Shanghai"
WORKDIR /cea
COPY ./cea-cron ./
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends -yq cron tzdata curl \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install --no-install-recommends -y nodejs \
    && apt-get install --no-install-recommends -y postfix \
    && crontab ./cea-cron \
    && npm install -g cea \
    && apt-get clean \
    && rm -rf \
    "/tmp/!(conf)" \
    /usr/share/doc/* \
    /var/cache/* \
    /var/lib/apt/lists/* \
    /var/tmp/* && npm cache clean --force;
CMD postfix start && cron -f
