FROM debian:stretch-slim

# Basic check it works.
RUN apt-get update && \
    apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

COPY ./run.sh ./run.sh

ENTRYPOINT ["./run.sh"]