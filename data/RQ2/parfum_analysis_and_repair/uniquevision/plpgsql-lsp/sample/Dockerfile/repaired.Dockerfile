FROM postgres:14

RUN apt update && apt install --no-install-recommends -y postgresql-$PG_MAJOR-plpgsql-check && rm -rf /var/lib/apt/lists/*;
