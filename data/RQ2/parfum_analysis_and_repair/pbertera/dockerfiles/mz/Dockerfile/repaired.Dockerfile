FROM debian

RUN apt-get update && apt-get install --no-install-recommends -y \
    mz \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "mz" ]
