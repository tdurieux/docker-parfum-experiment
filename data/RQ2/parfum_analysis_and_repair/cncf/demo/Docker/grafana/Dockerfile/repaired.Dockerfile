FROM grafana/grafana:3.1.1

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

COPY dashboards /dashboards
COPY run.sh /run.sh

EXPOSE 3000
ENTRYPOINT /run.sh
