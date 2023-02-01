FROM debian:stretch

ARG BUNDLE_DIR

RUN apt-get update
RUN apt-get install --no-install-recommends openssh-client -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
 apt-get install --no-install-recommends -y curl && \
 curl -f -o helm.tgz https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz && \
 tar -xzf helm.tgz && \
 mv linux-amd64/helm /usr/local/bin && \
 rm helm.tgz && rm -rf /var/lib/apt/lists/*;
RUN helm init --client-only

# PORTER_MIXINS

COPY scripts/ $BUNDLE_DIR