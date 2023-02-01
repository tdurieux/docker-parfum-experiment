FROM registry.hub.docker.com/library/golang:1.17
WORKDIR /workspace
RUN apt update && apt install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

CMD ["sh", "./testdata/runtest.sh"]
