FROM debian:testing-20210111-slim
USER root
COPY scripts scripts
WORKDIR scripts
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget && \
    ./deploy.sh && rm -rf /var/lib/apt/lists/*;
COPY install/gget /usr/local/bin/gget
