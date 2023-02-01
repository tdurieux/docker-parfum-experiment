FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y jq python2.7 python-pip curl && rm -rf /var/lib/apt/lists/*;
RUN python -m pip install --force-reinstall pip && \
    pip install --no-cache-dir aliyun-python-sdk-ecs && \
    pip install --no-cache-dir aliyuncli
COPY storage /usr/bin/
COPY abs/rancher-abs common/* /usr/bin/
RUN chmod a+x /usr/bin/rancher-abs
CMD ["start.sh", "storage", "--driver-name", "rancher-abs"]
