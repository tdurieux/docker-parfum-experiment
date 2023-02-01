FROM ubuntu:16.04
LABEL maintainer="nlkey2022@gmail.com"
RUN apt update && \
    apt install --no-install-recommends -y python3 python3-pip && \
    pip3 install --no-cache-dir flask requests && rm -rf /var/lib/apt/lists/*;

COPY worker.py /tmp/worker.py
ENTRYPOINT ["python3", "/tmp/worker.py"]
