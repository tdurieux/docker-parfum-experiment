FROM postgres:13

LABEL maintainer="Eric Deandrea edeandrea@redhat.com"

ENV POSTGRES_USER=fruits \
    POSTGRES_PASSWORD=fruits \
    POSTGRES_DB=fruits \
    INIT_DIR=/docker-entrypoint-initdb.d/

RUN mkdir -p $INIT_DIR
COPY src/test/resources/db/ $INIT_DIR