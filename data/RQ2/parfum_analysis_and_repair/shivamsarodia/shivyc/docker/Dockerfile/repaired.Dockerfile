FROM ubuntu:artful
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    gcc \
    vim && rm -rf /var/lib/apt/lists/*;
CMD pip3 install -e . && /bin/bash
