# Base image.
FROM debian:9

# Install dependencies.
RUN apt update && apt install -y \
    make \
    gcc \
    libhidapi-dev \
    libpython3.5-dev \
    python3
