ARG SUPERSET_VERSION

FROM apache/superset:${SUPERSET_VERSION}

USER root

RUN pip install --no-cache-dir mysqlclient
RUN pip install --no-cache-dir psycopg2
RUN pip install --no-cache-dir sqlalchemy-trino

USER superset

EXPOSE 8088
