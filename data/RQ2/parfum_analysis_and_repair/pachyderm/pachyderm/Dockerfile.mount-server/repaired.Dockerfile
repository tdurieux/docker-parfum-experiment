FROM debian:buster-slim
RUN apt update && apt install --no-install-recommends -y ca-certificates fuse && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /pfs
COPY LICENSE /LICENSE
COPY licenses /licenses
COPY mount-server /usr/local/bin/mount-server
