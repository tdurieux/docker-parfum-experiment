FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y jq curl nfs-common netbase && rm -rf /var/lib/apt/lists/*;
COPY storage /usr/bin/
COPY nfs/rancher-nfs common/* /usr/bin/
CMD ["start.sh", "storage", "--driver-name", "rancher-nfs"]
