FROM devkitpro/devkitarm
# ENV TWLNOPATCHSRLHEADER=1
RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y python && \
  rm -rf /var/lib/apt/lists/*
WORKDIR /data
