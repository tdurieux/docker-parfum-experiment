RUN apt-get update && \
    apt-get install -y --no-install-recommends --fix-missing curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.3/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv kubectl /usr/local/bin
