FROM golangci/golangci-lint:latest
WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends -y \
    liblzo2-dev \
    libbrotli-dev \
    libsodium-dev \
    build-essential \
    gcc \
    cmake \
    libc-dev && rm -rf /var/lib/apt/lists/*;
