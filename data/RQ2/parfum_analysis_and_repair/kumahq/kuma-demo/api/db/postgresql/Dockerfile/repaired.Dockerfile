# docker build . -t kvn0218/postgres:latest
# docker push kvn0218/postgres:latest

FROM postgres:alpine

RUN mkdir -p /tmp/psql_data/

RUN echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf

# Expose the PostgreSQL port