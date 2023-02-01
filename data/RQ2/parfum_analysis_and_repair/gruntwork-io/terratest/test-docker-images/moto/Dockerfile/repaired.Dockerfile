FROM ubuntu:16.04

# Reduce Docker image size per https://blog.replicated.com/refactoring-a-dockerfile-for-image-size/
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y \
    python-pip && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --upgrade setuptools && \
    pip install --no-cache-dir --upgrade flask && \
    pip install --no-cache-dir --upgrade pyOpenSSL && \
    pip install --no-cache-dir --upgrade moto