FROM ubuntu:20.04
RUN apt-get update && apt-get install --no-install-recommends -y cron curl && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
RUN curl -f https://dist.ipfs.io/go-ipfs/v0.13.0/go-ipfs_v0.13.0_linux-amd64.tar.gz > go-ipfs.tar.gz && tar xvfz go-ipfs.tar.gz && cd go-ipfs && ./install.sh && rm go-ipfs.tar.gz
ADD ./publish.sh ./publish.sh
ADD ./init-config.sh ./init-config.sh
ADD ./entrypoint.sh ./entrypoint.sh
ADD ./cron.job ./cron.job
# Terminate and auto-restart container if ipfs daemon crashes
HEALTHCHECK --interval=2m CMD curl http://localhost:8080 || pkill entrypoint.sh
ENTRYPOINT ./entrypoint.sh
