FROM altinity/clickhouse-server:21.8.12.29.altinitydev.arm
COPY ./initdb.sh /docker-entrypoint-initdb.d/