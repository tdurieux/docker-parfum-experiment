FROM ubuntu:14.04

RUN apt-get update && \
  apt-get install --no-install-recommends -y python libnss3 wget && rm -rf /var/lib/apt/lists/*;

# Download SNAP binary
RUN mkdir /opt/SNAP
WORKDIR /opt/SNAP
RUN wget https://snap.cs.berkeley.edu/downloads/snap-beta.18-linux.tar.gz
RUN tar xzvf snap-beta.18-linux.tar.gz && rm snap-beta.18-linux.tar.gz
RUN chmod +x snap-aligner

ENTRYPOINT ["/opt/SNAP/snap-aligner"]