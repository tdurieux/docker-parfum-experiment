FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y curl vim postgresql && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/bin
RUN curl -f -Lo migrant_download.tar.gz https://github.com/jaemk/migrant/releases/download/v0.11.4/migrant-v0.11.4-x86_64-unknown-linux-musl.tar.gz
RUN tar -xf migrant_download.tar.gz && rm migrant_download.tar.gz
RUN rm -f migrant_download.tar.gz

