FROM {{ .From }}
{{- $postgres_exporter := index .Packages "postgres_exporter" }}

ARG EXPORTER_VERSION={{ $postgres_exporter.Version }}
RUN env && apt-get update && \
	apt-get install --no-install-recommends -y wget && \
	wget https://github.com/wrouesnel/postgres_exporter/releases/download/v${EXPORTER_VERSION}/postgres_exporter_v${EXPORTER_VERSION}_linux-amd64.tar.gz && \
	tar xzvf postgres_exporter_v${EXPORTER_VERSION}_linux-amd64.tar.gz && \
	mv postgres_exporter_v${EXPORTER_VERSION}_linux-amd64/postgres_exporter / && \
	rm postgres_exporter_v${EXPORTER_VERSION}_linux-amd64.tar.gz && \
	rmdir postgres_exporter_v${EXPORTER_VERSION}_linux-amd64 && \
	mkdir -p /var/tmp/licence/postgres_exporter/ && \
        cd /var/tmp/licence/postgres_exporter/ && \
	wget https://raw.githubusercontent.com/wrouesnel/postgres_exporter/master/LICENSE && \
	apt-get purge -y --auto-remove wget && \
	rm -rf /var/lib/apt/lists/*

FROM {{ .From }}
COPY --from=0 /postgres_exporter /
COPY --from=0 /var/tmp/licence/ /usr/share/doc/
EXPOSE 9187
ENTRYPOINT [ "/postgres_exporter" ]

