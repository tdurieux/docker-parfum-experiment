FROM python:3.8-slim as base
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL ["/bin/bash", "-c"]

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libev4 libssl1.1 libisal2 libnss3 \
        libpq5 libmariadb3 \
        curl locales; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Firefox + Gecko driver. For Ubuntu, using `apt install firefox firefox-geckodriver`
ARG GECKO_DRIVER_VERSION=v0.29.0
RUN set -eux; cd /tmp/; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        xvfb libxi6 libgconf-2-4 \
        firefox-esr; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    curl -f -sSL "https://github.com/mozilla/geckodriver/releases/download/${GECKO_DRIVER_VERSION}/geckodriver-${GECKO_DRIVER_VERSION}-linux64.tar.gz" \
        | tar -xzf - -C /usr/local/bin --no-same-owner;

RUN set -eux; \
    sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen; \
    locale-gen; \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8;

ENV SUPERSET_HOME="/opt/superset"
RUN set -eux; \
    useradd -ms "/bin/bash" --uid=1000 superset; \
    mkdir -p "${SUPERSET_HOME}"; \
    chown -R superset: "${SUPERSET_HOME}";

WORKDIR ${SUPERSET_HOME}

FROM base AS builder

ARG SUPERSET_VERSION=1.0.1

RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        build-essential \

        unixodbc-dev \

        default-libmysqlclient-dev \

        libmemcached-dev \

        libsasl2-dev; rm -rf /var/lib/apt/lists/*;

RUN set -eux; \
    function join { local IFS="$1"; echo "${*:2}"; }; \
    SUPERSET_PACKAGES=( \
        # Cloud
        athena bigquery redshift \
        dremio snowflake teradata vertica exasol \
        # Database
        mysql postgres mmsql oracle db2 hana \
        clickhouse cockroachdb elasticsearch \
        excel gsheets \
        # Big Data
        drill druid hive impala kylin pinot presto \
        # Others
        cors thumbnails \
    ); \
    pip install --no-cache-dir "apache-superset[$(join ',' ${SUPERSET_PACKAGES[@]})]==${SUPERSET_VERSION}" \
        "gunicorn[gevent,eventlet]" "flower~=0.9" "authlib~=0.15" "redis~=3.5" "pylibmc~=1.6"; \

    rm -rf /usr/local/cx_Oracle-doc;

FROM base

COPY --from=builder /usr/local /usr/local
COPY ./scripts/superset/* /usr/local/bin/
RUN mv /usr/local/bin/trino.py /usr/local/lib/python3.8/site-packages/superset/db_engine_specs/

USER superset
EXPOSE 8088 5555
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
