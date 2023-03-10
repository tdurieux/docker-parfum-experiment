FROM iakunin/liquibase-postgres:42.1.4-3.8.9

ENV LIQUIBASE_CHANGELOG=db/changelog/db.changelog-master.yaml

RUN mkdir /workspace/db
COPY src/main/resources/db /workspace/db