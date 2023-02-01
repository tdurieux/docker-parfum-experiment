#
# Stock Grafana + a few custom dashboards
#

FROM grafana/grafana:2.6.0

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

COPY dashboards /dashboards
COPY run.sh /run.sh

EXPOSE 3000
ENTRYPOINT /run.sh
