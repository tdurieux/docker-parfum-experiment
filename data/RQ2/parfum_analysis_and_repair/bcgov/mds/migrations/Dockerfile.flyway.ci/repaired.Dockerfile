FROM flyway/flyway:7.14-alpine
ENV FLYWAY_HOME=/flyway

USER 0

RUN apk add --no-cache gettext

COPY sql/* /flyway/sql/
COPY scripts/* /flyway/scripts/


ENV FLYWAY_VERSION=5.2.4

# Copy over the SQL files and scripts
COPY sql/* $FLYWAY_HOME/sql/
COPY scripts/* $FLYWAY_HOME/scripts/

RUN chmod -R 777 $FLYWAY_HOME

USER 1001

ENTRYPOINT /flyway/scripts/run_migrations.sh