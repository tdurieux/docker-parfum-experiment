FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y curl jq && rm -rf /var/lib/apt/lists/*;
COPY storage common/* longhorn/rancher-longhorn /usr/bin/
CMD ["start.sh", "storage", "--driver-name", "rancher-longhorn"]
