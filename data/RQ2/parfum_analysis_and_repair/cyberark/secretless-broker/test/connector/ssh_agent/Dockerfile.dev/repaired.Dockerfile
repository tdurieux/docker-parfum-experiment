FROM secretless-dev

RUN apt-get update && \
    apt-get install --no-install-recommends -y ssh && rm -rf /var/lib/apt/lists/*;
