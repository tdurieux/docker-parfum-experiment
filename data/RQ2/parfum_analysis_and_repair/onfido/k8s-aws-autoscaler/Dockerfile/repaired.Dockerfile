FROM alpine

RUN apk add --update curl bash jq python py-pip bc sed \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir awscli \
    && rm -rf /var/cache/apk/*

RUN cd /usr/local/bin \
    && curl -f -O https://storage.googleapis.com/kubernetes-release/release/v1.6.2/bin/linux/amd64/kubectl \
    && chmod 755 /usr/local/bin/kubectl

COPY autoscale.sh rotate-nodes.sh /bin/
RUN chmod +x /bin/autoscale.sh && chmod +x /bin/rotate-nodes.sh

ENV INTERVAL 300
ENV MAX_AGE_DAYS 2

CMD ["bash", "/bin/autoscale.sh"]
