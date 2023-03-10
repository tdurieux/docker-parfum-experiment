FROM grafana/grafana:latest
USER root
RUN apk add --no-cache sqlite
USER grafana
COPY --chown=grafana:root grafana.db.sql /var/lib/grafana/grafana.db.sql
RUN cat /var/lib/grafana/grafana.db.sql | sqlite3 /var/lib/grafana/grafana.db && rm /var/lib/grafana/grafana.db.sql
