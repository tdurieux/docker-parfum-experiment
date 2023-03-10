FROM ubuntu:artful

RUN apt-get -qq update && \
    apt-get install --no-install-recommends -y sudo docker.io git make btrfs-tools libdevmapper-dev libgpgme-dev libostree-dev && rm -rf /var/lib/apt/lists/*;

ADD https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz /tmp

RUN tar -C /usr/local -xzf /tmp/go1.9.2.linux-amd64.tar.gz && \
    rm /tmp/go1.9.2.linux-amd64.tar.gz && \
    ln -s /usr/local/go/bin/* /usr/local/bin/
