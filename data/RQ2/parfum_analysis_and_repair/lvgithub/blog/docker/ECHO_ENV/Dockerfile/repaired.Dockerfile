FROM ubuntu:18.04
RUN apt-get update \
    && apt-get install --no-install-recommends -y curl \
    && rm -rf /var/lib/apt/lists/*
ENV name Cloud Man 
ENTRYPOINT ["/bin/sh", "-c", "echo Hello, $name"]
