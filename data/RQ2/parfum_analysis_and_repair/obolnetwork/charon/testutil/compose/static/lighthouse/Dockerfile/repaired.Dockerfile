FROM sigp/lighthouse:latest

RUN apt-get update && apt-get install --no-install-recommends -y curl jq wget && rm -rf /var/lib/apt/lists/*;

ENV YQ_VERSION=v4.23.1
ENV YQ_BINARY=yq_linux_amd64
RUN wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY} -O /usr/bin/yq \
    && chmod +x /usr/bin/yq

ENTRYPOINT ["/compose/lighthouse/run.sh"]
