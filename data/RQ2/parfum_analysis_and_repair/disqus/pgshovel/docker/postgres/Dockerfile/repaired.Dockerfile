FROM postgres:9.3

RUN apt-get update && \
    apt-get install --no-install-recommends -y postgresql-${PG_MAJOR}-pgq3 postgresql-plpython-${PG_MAJOR} && \
        rm -rf /var/lib/apt/lists/*

CMD ["postgres", "-c", "max_prepared_transactions=10"]
