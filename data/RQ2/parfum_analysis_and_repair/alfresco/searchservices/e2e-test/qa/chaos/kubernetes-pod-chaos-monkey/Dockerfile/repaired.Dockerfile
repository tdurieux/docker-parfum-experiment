FROM debian:jessie

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
  curl && rm -rf /var/lib/apt/lists/*;

ARG KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl
RUN cd /usr/local/bin && curl -f -O $KUBECTL_URL && chmod 755 kubectl

WORKDIR /usr/src/app
COPY chaos.sh ./
CMD ["bash", "/usr/src/app/chaos.sh"]
