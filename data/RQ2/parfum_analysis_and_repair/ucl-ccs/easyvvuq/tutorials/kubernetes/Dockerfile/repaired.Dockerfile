FROM ubuntu:latest

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y tini && \
    pip3 install --no-cache-dir easyvvuq && \
    git clone https://github.com/UCL-CCS/EasyVVUQ.git && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["tini", "--"]
