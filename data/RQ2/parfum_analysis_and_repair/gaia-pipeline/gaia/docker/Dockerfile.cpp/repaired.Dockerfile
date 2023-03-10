FROM debian:buster

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential autoconf git pkg-config \
    automake libtool curl make g++ unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# install protobuf first, then grpc
ENV GRPC_RELEASE_TAG v1.29.x
RUN git clone -b ${GRPC_RELEASE_TAG} https://github.com/grpc/grpc /var/local/git/grpc && \
	            cd /var/local/git/grpc && \
    git submodule update --init && \
    echo "--- installing protobuf ---" && \
    cd third_party/protobuf && \
    ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared && \
    make -j$(nproc) && make install && make clean && ldconfig && \
    echo "--- installing grpc ---" && \
    cd /var/local/git/grpc && \
    make -j$(nproc) && make install && make clean && ldconfig

# Gaia internal port and data path.
ENV GAIA_PORT=8080 \
    GAIA_HOME_PATH=/data

# Directory for the binary
WORKDIR /app

# Copy gaia binary into docker image
COPY gaia-linux-amd64 /app

# Fix permissions & setup known hosts file for ssh agent.
RUN chmod +x ./gaia-linux-amd64 \
    && mkdir -p /root/.ssh \
    && touch /root/.ssh/known_hosts \
    && chmod 600 /root/.ssh

# Set homepath as volume
VOLUME [ "${GAIA_HOME_PATH}" ]

# Expose port
EXPOSE ${GAIA_PORT}

# Copy entry point script
COPY docker/docker-entrypoint.sh /usr/local/bin/

# Start gaia
ENTRYPOINT [ "docker-entrypoint.sh" ]
