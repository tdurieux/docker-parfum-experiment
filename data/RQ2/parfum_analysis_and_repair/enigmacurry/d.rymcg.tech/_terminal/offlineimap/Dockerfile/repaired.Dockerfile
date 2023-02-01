FROM debian:bullseye
RUN apt-get update && \
    apt-get install --no-install-recommends -y offlineimap && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
