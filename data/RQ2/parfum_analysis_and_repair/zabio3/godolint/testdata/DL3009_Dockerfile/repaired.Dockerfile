FROM debian:1.12.0-stretch
RUN apt-get update && apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;

CMD ["go", "run", "main.go"]