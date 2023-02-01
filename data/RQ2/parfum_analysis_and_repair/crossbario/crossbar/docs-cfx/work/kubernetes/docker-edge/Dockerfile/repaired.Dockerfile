FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
COPY .crossbar /
COPY crossbarfx /
RUN chmod a+x /crossbarfx
ENTRYPOINT ["./crossbarfx", "edge", "start"]
