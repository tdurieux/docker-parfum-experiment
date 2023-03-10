FROM ubuntu:latest

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y cpio \
  dos2unix \
  fakeroot \
  genisoimage \
  git \
  gzip \
  isolinux \
  p7zip-full \
  pwgen \
  wget \
  whois \
  xorriso && rm -rf /var/lib/apt/lists/*;

COPY ubuntu ubuntu
COPY docker-entrypoint.sh .

ENTRYPOINT ["/docker-entrypoint.sh"]
