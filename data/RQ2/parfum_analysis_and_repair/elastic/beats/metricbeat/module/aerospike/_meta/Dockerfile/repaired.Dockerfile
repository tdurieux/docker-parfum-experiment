ARG AEROSPIKE_VERSION
FROM aerospike:${AEROSPIKE_VERSION}

RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
HEALTHCHECK --interval=1s --retries=90 CMD nc -z localhost 3000
