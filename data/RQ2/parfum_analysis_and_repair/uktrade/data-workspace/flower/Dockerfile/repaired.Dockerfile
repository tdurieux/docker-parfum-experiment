FROM debian:buster-slim AS base

ENV \
    LC_ALL=en_GB.UTF-8 \
    LANG=en_GB.UTF-8 \
    LANGUAGE=en_GB.UTF-8

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        libffi-dev \
        libldap2-dev \
        libsasl2-dev \
        libssl-dev \
        python3 \
        python3-dev \
        python3-pip && rm -rf /var/lib/apt/lists/*;

RUN adduser --disabled-password --gecos '' superset

COPY requirements.txt /

RUN \
    pip3 install --no-cache-dir --upgrade setuptools==57.5.0 pip && \
    pip3 install --no-cache-dir -r requirements.txt

COPY start.sh /start.sh

CMD ["/start.sh"]
