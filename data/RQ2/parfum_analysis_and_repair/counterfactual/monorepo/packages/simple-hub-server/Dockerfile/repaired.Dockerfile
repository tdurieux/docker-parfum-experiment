FROM postgres:11.5-alpine
COPY database/schema/playground_db.sql /docker-entrypoint-initdb.d/