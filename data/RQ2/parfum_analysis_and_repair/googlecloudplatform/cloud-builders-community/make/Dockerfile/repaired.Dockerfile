FROM debian

RUN apt-get update && \
  apt-get install --no-install-recommends -y ca-certificates curl wget build-essential && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["make"]
