# Copyright 2018-2022 Nick Brassel (@tzarc)
# SPDX-License-Identifier: GPL-3.0-or-later
FROM qmkfm/qmk_cli:latest

ENV PYTHONPATH=/app
WORKDIR /app

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y -qq curl python3 python3-pip gawk procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --no-cache-dir -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt

COPY app /app

RUN groupadd -g 88888 srv \
    && useradd -u 88888 -M -N -g 88888 -s /usr/sbin/nologin -d /app srv \
    && chown -R root:srv /app \
    && find /app -type d -exec chmod 755 '{}' + \
    && find /app -type f -exec chmod 644 '{}' + \
    && find /app -type f -name '*.sh' -exec chmod 755 '{}' +

USER 88888:88888

EXPOSE 80

CMD uvicorn main:app --host 0.0.0.0 --port 80