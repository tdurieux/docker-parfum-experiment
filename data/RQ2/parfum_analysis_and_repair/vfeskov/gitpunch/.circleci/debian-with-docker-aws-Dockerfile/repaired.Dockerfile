FROM debian
RUN apt-get update && \
    apt-get install --no-install-recommends curl python python-pip -y && \
    pip install --no-cache-dir awscli && \
    set -x && \
    VER="17.12.1-ce" && \
    curl -f -L -o /tmp/docker-$VER.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$VER.tgz && \
    tar -xz -C /tmp -f /tmp/docker-$VER.tgz && \
    mv /tmp/docker/* /usr/bin && rm /tmp/docker-$VER.tgz && rm -rf /var/lib/apt/lists/*;
