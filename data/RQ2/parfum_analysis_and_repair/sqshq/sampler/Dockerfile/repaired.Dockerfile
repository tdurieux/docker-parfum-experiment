FROM ubuntu:focal

ENV Sampler=/usr/local/bin/sampler

RUN apt-get update && apt-get upgrade --yes && apt-get install --no-install-recommends libasound-dev wget --yes \
  && wget https://github.com/sqshq/sampler/releases/download/v1.1.0/sampler-1.1.0-linux-amd64 -O $Sampler \
  && chmod +x $Sampler && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["sampler"]
