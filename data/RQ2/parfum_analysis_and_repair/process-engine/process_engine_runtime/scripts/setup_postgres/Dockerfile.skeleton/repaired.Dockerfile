FROM postgres
COPY skeleton.sql /docker-entrypoint-initdb.d/