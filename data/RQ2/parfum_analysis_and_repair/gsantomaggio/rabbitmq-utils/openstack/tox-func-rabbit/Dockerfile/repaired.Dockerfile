from rabbitmq

RUN apt-get update && \
    apt-get -y --no-install-recommends install gcc \
    python3 \
    git \
    python-tox \
    python3-dev && rm -rf /var/lib/apt/lists/*;
