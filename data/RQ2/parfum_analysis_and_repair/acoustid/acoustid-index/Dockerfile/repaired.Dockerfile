FROM ubuntu:20.04

RUN useradd -m -s /bin/bash -u 1000 acoustid

ADD acoustid-index.deb /tmp/
RUN apt update && apt install --no-install-recommends -y /tmp/acoustid-index.deb && rm /tmp/acoustid-index.deb && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /var/lib/acoustid-index && chown -R acoustid /var/lib/acoustid-index
VOLUME ["/var/lib/acoustid-index"]

RUN apt-get update && \
    apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;

USER acoustid
EXPOSE 6080
EXPOSE 6081
EXPOSE 6082

CMD ["fpi-server", "--directory", "/var/lib/acoustid-index", "--address", "0.0.0.0", "--port", "6080", "--http-address", "0.0.0.0", "--http-port", "6081", "--grpc-address", "0.0.0.0", "--grpc-port", "6082"]
