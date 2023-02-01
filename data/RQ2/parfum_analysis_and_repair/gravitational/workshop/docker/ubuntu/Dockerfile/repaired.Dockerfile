FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["curl"]
