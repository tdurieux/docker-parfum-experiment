FROM docker.elastic.co/observability/stream:v0.6.1

RUN apt update && \
    apt -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
ENV PORT="8080"
COPY files /files
HEALTHCHECK --interval=1s --retries=600 CMD curl -X POST http://localhost:8080/token
CMD [ "http-server", "--addr=:8080", "--config=/files/config.yml" ]
