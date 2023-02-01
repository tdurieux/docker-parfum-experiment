FROM httpd:latest

RUN apt update \
 && apt install --no-install-recommends -y \
    python3 \
    python3-pip \
 && rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache-dir sphinx \
 && rm -rf ~/.cache/pip/*
