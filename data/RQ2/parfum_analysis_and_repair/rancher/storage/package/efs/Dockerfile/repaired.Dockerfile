FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y jq python2.7 python-pip curl nfs-common dnsutils && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli
COPY storage /usr/bin/
COPY efs/rancher-efs common/* /usr/bin/
CMD ["start.sh", "storage", "--driver-name", "rancher-efs"]
