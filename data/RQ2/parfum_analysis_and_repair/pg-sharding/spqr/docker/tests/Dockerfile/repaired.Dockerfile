FROM spqr_spqrbase

COPY --from=networld/grpcurl /grpcurl /usr/bin/

RUN mv /router/spqr-stress /usr/local/bin/spqr-stress

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moskow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y --no-install-recommends \
	curl \
	lsb-release \
	make \
	ca-certificates \
	gnupg \
	openssl musl telnet host vim etcd-client && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo postgresql-13 && rm -rf /var/lib/apt/lists/*;

COPY ./docker/tests/bin/ /usr/local/bin/

RUN chmod a+x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
