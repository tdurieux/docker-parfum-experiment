FROM debian:buster
LABEL maintainer="mfig@agoric.com"

RUN apt-get update --allow-releaseinfo-change \
    && apt-get install --no-install-recommends -y init openssh-server sudo curl \
      python python3-venv python3-dev vim jq less \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

CMD ["/sbin/init"]
