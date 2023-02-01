ARG COCKROACHDB_VERSION
FROM cockroachdb/cockroach:v${COCKROACHDB_VERSION}

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

HEALTHCHECK --interval=1s --retries=90 CMD curl -q http://localhost:8080/_stats/vars

CMD ["start", "--insecure"]
