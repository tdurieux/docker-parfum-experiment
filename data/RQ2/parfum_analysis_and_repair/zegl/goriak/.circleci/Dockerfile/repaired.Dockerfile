FROM ubuntu:16.04

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y curl git build-essential && rm -rf /var/lib/apt/lists/*;

# Install Go
RUN curl -f -O https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz && \
    tar -xvf go1.11.4.linux-amd64.tar.gz && \
    mv go /usr/local && \
    cp /usr/local/go/bin/go /usr/bin/go && rm go1.11.4.linux-amd64.tar.gz

# Install and configure Riak KV
RUN curl -f -s https://packagecloud.io/install/repositories/basho/riak/script.deb.sh | bash
RUN apt-get update && apt-get install --no-install-recommends -y riak=2.2.0-1 && \
    sed -i 's/storage_backend.*/storage_backend = leveldb/' /etc/riak/riak.conf && \
    service riak restart && \
    riak version && \
    riak-admin bucket-type create maps '{"props":{"datatype":"map","backend":"leveldb"}}' && \
    riak-admin bucket-type activate maps && \
    riak-admin bucket-type create tests '{"props":{"backend":"leveldb"}}' && \
    riak-admin bucket-type activate tests && \
    riak-admin bucket-type create hlls '{"props":{"datatype":"hll","backend":"leveldb"}}' && \
    riak-admin bucket-type activate hlls && rm -rf /var/lib/apt/lists/*;

