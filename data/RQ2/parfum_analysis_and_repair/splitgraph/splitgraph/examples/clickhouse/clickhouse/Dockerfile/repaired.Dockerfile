FROM yandex/clickhouse-server:latest

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y odbc-postgresql unixodbc && \
    rm -rf rm -rf /var/lib/apt/lists/*

COPY odbc.ini odbcinst.ini /etc/
