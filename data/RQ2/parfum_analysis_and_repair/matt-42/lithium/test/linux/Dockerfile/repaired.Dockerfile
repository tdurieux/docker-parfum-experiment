FROM buildpack-deps:focal
RUN apt-get update && apt-get install --no-install-recommends -yqq libboost-context-dev libboost-dev wget libmariadb-dev \
            postgresql-server-dev-12 postgresql-12 libpq-dev cmake sudo mariadb-server clang-9 \
            curl zip unzip tar && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /usr/local/var/postgres
RUN mkdir -p /usr/local/var/postgres
RUN chown postgres:postgres /usr/local/var/postgres
