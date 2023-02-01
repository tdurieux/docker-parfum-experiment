ARG BRANCH
FROM bosh/integration:${BRANCH}

ARG DB_VERSION

# To build all gems and install ruby
RUN apt update && apt -yq --no-install-recommends install \
    libmysqlclient-dev libpq-dev libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt update

RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y \
	postgresql-$DB_VERSION \
	postgresql-client-$DB_VERSION \
	&& apt clean && rm -rf /var/lib/apt/lists/*;

ADD trust_pg_hba.conf /tmp/pg_hba.conf
RUN cp /tmp/pg_hba.conf /etc/postgresql/$DB_VERSION/main/pg_hba.conf
