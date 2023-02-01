FROM ubuntu:18.04

# Install dependencies necessary to run realm server
RUN apt-get update && apt-get install --no-install-recommends -y \
    libssl-dev \
    libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /app/config

COPY --from=builder /app/bin/realm_server /app
COPY --from=builder /app/docker/realm_server/run_server.sh /app
COPY --from=builder /app/docker/realm_server/realm_server.cfg /app/config/realm_server.cfg

WORKDIR /app

ENTRYPOINT [ "/app/run_server.sh" ]
