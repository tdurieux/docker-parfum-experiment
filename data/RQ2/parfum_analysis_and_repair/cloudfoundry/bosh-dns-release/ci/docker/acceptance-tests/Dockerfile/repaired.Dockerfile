FROM bosh/main-bosh-docker

RUN apt-get update && \
  apt-get install --no-install-recommends -y dnsutils && \
  rm -rf /var/lib/apt/lists/*
