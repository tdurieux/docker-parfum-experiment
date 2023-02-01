FROM postgres:10

RUN sed -i 's/$/ 9.3/' /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get install -y --no-install-recommends \
		postgresql-9.3=9.3.25-1.pgdg90+1 \
		postgresql-contrib-9.3=9.3.25-1.pgdg90+1 \
	&& rm -rf /var/lib/apt/lists/*

ENV PGBINOLD /usr/lib/postgresql/9.3/bin
ENV PGBINNEW /usr/lib/postgresql/10/bin

ENV PGDATAOLD /var/lib/postgresql/9.3/data
ENV PGDATANEW /var/lib/postgresql/10/data

RUN mkdir -p "$PGDATAOLD" "$PGDATANEW" \
	&& chown -R postgres:postgres /var/lib/postgresql

WORKDIR /var/lib/postgresql

COPY docker-upgrade /usr/local/bin/

ENTRYPOINT ["docker-upgrade"]

# recommended: --link
CMD ["pg_upgrade"]
