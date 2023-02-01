FROM postgres
RUN apt-get update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
ENV POSTGRES_DB pagila
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres

COPY *.sh /docker-entrypoint-initdb.d/
EXPOSE 5432

CMD ["postgres"]
