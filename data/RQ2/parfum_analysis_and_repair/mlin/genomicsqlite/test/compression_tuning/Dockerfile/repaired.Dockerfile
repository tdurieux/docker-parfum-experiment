FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update && apt-get install --no-install-recommends -y samtools zstd && rm -rf /var/lib/apt/lists/*;
