FROM ubuntu AS builder

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/Vertamedia/clickhouse-grafana.git

FROM grafana/grafana:7.5.7

COPY --from=builder /clickhouse-grafana /var/lib/grafana/plugins