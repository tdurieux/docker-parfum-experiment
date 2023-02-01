# Copy and extract HEAVY.AI tarball. In own stage so that the temporary tarball
# isn't included in a layer.
FROM ubuntu:18.04 AS extract

WORKDIR /opt/heavyai/
COPY heavyai-latest-Linux-x86_64-cpu.tar.gz /opt/heavyai/
RUN tar xvf heavyai-latest-Linux-x86_64-cpu.tar.gz --strip-components=1 && \
    rm -rf heavyai-latest-Linux-x86_64-cpu.tar.gz

# Build final stage