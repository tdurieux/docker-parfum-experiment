FROM secretless-dev

RUN apt-get update && \
    apt-get install --no-install-recommends -y default-mysql-client && rm -rf /var/lib/apt/lists/*;
