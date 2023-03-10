FROM postgres:11-alpine
ENV POSTGRES_DB postgres
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD password
COPY sql/postgresql/*.sql /docker-entrypoint-initdb.d/

EXPOSE 5432