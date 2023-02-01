# Only flyway latest supports ARM arch.
FROM flyway/flyway:latest

USER root

# apk replaced with apt. apk is only for alpine
RUN apt-get update && apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;

COPY sql/* /flyway/sql/
COPY scripts/* /flyway/scripts/

ENTRYPOINT /flyway/scripts/run_migrations.sh
