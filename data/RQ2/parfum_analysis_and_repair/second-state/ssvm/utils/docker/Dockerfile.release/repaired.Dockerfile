FROM ubuntu:20.04
ARG VERSION
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install --no-install-recommends -y curl git && \
    curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -p /usr/local -e all -v $VERSION && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
CMD ["/usr/local/bin/wasmedge"]
