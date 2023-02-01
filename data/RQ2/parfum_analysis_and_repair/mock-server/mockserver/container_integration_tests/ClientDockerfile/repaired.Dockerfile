FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    jq && rm -rf /var/lib/apt/lists/*;

CMD ["sleep", "86400"]