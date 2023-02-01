FROM ubuntu:17.10

RUN apt-get update && apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY linux64/src/sample /app/bin/sample
COPY linux64/lib /app/lib

ENTRYPOINT ["/app/bin/sample"]
