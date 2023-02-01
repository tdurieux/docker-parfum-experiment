FROM debian:stretch-slim

# Dependencies
RUN apt-get -y update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install \
    dumb-init \
    libssl1.1 \
    libprocps6 \
    libgmp10 \
    libgomp1 \
    libffi6 && \
  rm -rf /var/lib/apt/lists/*

# coda package
# FIXME: The copy creates a layer, wasting space.
COPY coda.deb /tmp/
RUN dpkg -i /tmp/coda.deb

# FIXME: unpack verification keys

ENTRYPOINT ["/usr/bin/dumb-init", "/usr/local/bin/coda"]
