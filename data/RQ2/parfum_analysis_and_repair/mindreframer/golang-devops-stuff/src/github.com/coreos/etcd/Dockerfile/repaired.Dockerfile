FROM ubuntu:12.04
# Let's install go just like Docker (from source).
RUN apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -qy build-essential curl git && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://storage.googleapis.com/golang/go1.3.src.tar.gz | tar -v -C /usr/local -xz
RUN cd /usr/local/go/src && ./make.bash --no-clean 2>&1
ENV PATH /usr/local/go/bin:$PATH
ADD . /opt/etcd
RUN cd /opt/etcd && ./build
EXPOSE 4001 7001
ENTRYPOINT ["/opt/etcd/bin/etcd"]

