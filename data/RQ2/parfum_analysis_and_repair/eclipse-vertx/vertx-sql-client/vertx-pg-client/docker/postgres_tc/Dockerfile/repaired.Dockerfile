FROM postgres
ENV POSTGRES_DB postgres
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres
RUN apt-get update && apt-get install --no-install-recommends -y iproute && rm -rf /var/lib/apt/lists/*;
COPY create-postgres.sql /docker-entrypoint-initdb.d/
