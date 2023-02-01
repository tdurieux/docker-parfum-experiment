FROM postgres:%%POSTGRES_NEW%%

RUN sed -i 's/$/ %%POSTGRES_OLD%%/' /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get install -y --no-install-recommends \
		postgresql-%%POSTGRES_OLD%%=%%POSTGRES_OLD_VERSION%% \
		postgresql-contrib-%%POSTGRES_OLD%%=%%POSTGRES_OLD_VERSION%% \
	&& rm -rf /var/lib/apt/lists/*

ENV PGBINOLD /usr/lib/postgresql/%%POSTGRES_OLD%%/bin
ENV PGBINNEW /usr/lib/postgresql/%%POSTGRES_NEW%%/bin

ENV PGDATAOLD /var/lib/postgresql/%%POSTGRES_OLD%%/data
ENV PGDATANEW /var/lib/postgresql/%%POSTGRES_NEW%%/data

RUN mkdir -p "$PGDATAOLD" "$PGDATANEW" \
	&& chown -R postgres:postgres /var/lib/postgresql

WORKDIR /var/lib/postgresql

COPY docker-upgrade /usr/local/bin/

ENTRYPOINT ["docker-upgrade"]

# recommended: --link
CMD ["pg_upgrade"]
