FROM ubuntu:12.04
# Let's install go just like Docker (from source).
RUN apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -qy libpcap-dev curl git make && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://storage.googleapis.com/golang/go1.3.1.src.tar.gz | tar -v -C /usr/local -xz
RUN cd /usr/local/go/src && ./make.bash --no-clean 2>&1
RUN mkdir -p /usr/local/source
ENV GOPATH /usr/local/source
ENV PATH /usr/local/go/bin:$PATH
ADD . /opt/dnas
RUN cd /opt/dnas && make
ENTRYPOINT ["/opt/dnas/bin/dnas"]
