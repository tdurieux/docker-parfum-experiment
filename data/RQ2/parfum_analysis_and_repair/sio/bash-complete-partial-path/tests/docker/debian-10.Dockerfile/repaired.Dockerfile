FROM debian:10-slim

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        make \
        curl \
        python3 \
        python3-venv \
        bash \
        sed \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
