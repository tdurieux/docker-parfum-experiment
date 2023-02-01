FROM cassandra:latest

LABEL maintainer="LitmusChaos"

RUN apt-get update && apt-get install --no-install-recommends -y netcat-openbsd curl && rm -rf /var/lib/apt/lists/*;

COPY cassandra-liveness-check.sh webserver.sh /

EXPOSE 8088