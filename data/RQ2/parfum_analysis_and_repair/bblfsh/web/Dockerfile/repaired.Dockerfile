FROM debian:stretch-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;
ADD build/bin/bblfsh-web /bin/bblfsh-web
ENTRYPOINT ["/bin/bblfsh-web", "-addr", ":8080"]
