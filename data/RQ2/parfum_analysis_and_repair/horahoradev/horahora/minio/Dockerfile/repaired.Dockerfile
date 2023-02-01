FROM ubuntu:focal

# install minio binaries
RUN apt -y update && \
  apt -y --no-install-recommends install wget && \
  wget https://dl.min.io/server/minio/release/linux-amd64/minio -O /usr/local/bin/minio && \
  chmod +x /usr/local/bin/minio && \
  wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && \
  chmod +x /usr/local/bin/mc && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
