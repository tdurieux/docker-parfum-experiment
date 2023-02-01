# Build extensions
FROM postgres:13 AS builder
RUN apt-get update && apt-get install --no-install-recommends -y git make postgresql-server-dev-13 && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/theory/pgtap
RUN cd pgtap && make && make install && cd ..
RUN git clone https://github.com/pgpartman/pg_partman
RUN cd pg_partman && make NO_BGW=1 install

# Build final image
FROM postgres:13
COPY --from=builder /usr/share/postgresql/13/extension/pgtap* /usr/share/postgresql/13/extension/
COPY --from=builder /usr/share/postgresql/13/extension/pg_partman* /usr/share/postgresql/13/extension/
