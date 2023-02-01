FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y jq python2.7 python-pip curl nvme-cli && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli
COPY storage /usr/bin/
COPY ebs/rancher-ebs common/* /usr/bin/
CMD ["start.sh", "storage", "--driver-name", "rancher-ebs"]
