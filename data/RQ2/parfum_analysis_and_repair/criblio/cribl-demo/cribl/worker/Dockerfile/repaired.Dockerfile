ARG TAG=latest
FROM cribl/cribl:$TAG
RUN apt-get update && apt-get install -y --no-install-recommends mtr python python-pip && \
    pip install --no-cache-dir speedtest-cli && rm -rf /var/lib/apt/lists/*;
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt-get install --no-install-recommends -y docker.io && rm -rf /var/lib/apt/lists/*;

