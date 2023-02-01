FROM ubuntu:14.04

RUN apt-get update && \
  apt-get install --no-install-recommends -y python libnss3 curl && rm -rf /var/lib/apt/lists/*;

# Download Strelka binary
RUN mkdir /opt/strelka && \
  curl -f -L https://github.com/Illumina/strelka/releases/download/v2.7.1/strelka-2.7.1.centos5_x86_64.tar.bz2 \
  | tar --strip-components=1 -xjC /opt/strelka
