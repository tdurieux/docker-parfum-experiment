RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
