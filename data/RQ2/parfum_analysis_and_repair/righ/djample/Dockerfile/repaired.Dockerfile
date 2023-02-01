FROM ubuntu:18.04 AS djample-base

RUN useradd www --create-home --shell /bin/bash
WORKDIR /home/www

RUN set -x; \
  apt-get update -y && \
  apt-get install --no-install-recommends -y cron && \
  apt-get install --no-install-recommends -y python3.6 python3-pip python3.6-venv && \
  apt-get install --no-install-recommends -y postgresql-client && \
  apt-get install --no-install-recommends -y libpcre3 libpcre3-dev && \
  ln -s /usr/bin/python3.6 /usr/bin/python && rm -rf /var/lib/apt/lists/*;
