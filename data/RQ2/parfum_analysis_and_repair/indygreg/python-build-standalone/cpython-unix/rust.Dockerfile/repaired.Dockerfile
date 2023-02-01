{% include 'base.Dockerfile' %}
RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    libc6-dev \
    python2.7 \
    python \
    tar && rm -rf /var/lib/apt/lists/*;