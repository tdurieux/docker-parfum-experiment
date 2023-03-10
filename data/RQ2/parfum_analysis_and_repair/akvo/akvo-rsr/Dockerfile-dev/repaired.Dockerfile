FROM python:3.8.1-buster

RUN set -ex; apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    curl git postgresql-client runit cron \
    libjpeg-dev libfreetype6-dev \
    libffi-dev libssl-dev gettext \
    libfontenc1 xfonts-encodings xfonts-utils xfonts-75dpi xfonts-base \
    libxml2-dev libxslt1-dev zlib1g-dev python3-dev gosu && \
    rm -rf /var/lib/apt/lists/*

RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

ENV NODE_VERSION 10.15.0

RUN curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

RUN addgroup akvo && adduser --disabled-password --home /home/akvo --shell /bin/bash --ingroup akvo --gecos "" akvo

WORKDIR /var/akvo/rsr/code

COPY scripts/deployment/pip/requirements/2_rsr.txt ./
RUN pip install --no-cache-dir -r 2_rsr.txt

COPY scripts/deployment/pip/requirements/3_dev.txt ./
RUN pip install --no-cache-dir -r 3_dev.txt

ENV PYTHONUNBUFFERED 1

CMD [ "scripts/docker/dev/run-as-user.sh", "scripts/docker/dev/start-django.sh"]
