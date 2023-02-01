FROM openeuphoria/euphoria:latest
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends -y build-essential git && rm -rf /var/lib/apt/lists/*;
