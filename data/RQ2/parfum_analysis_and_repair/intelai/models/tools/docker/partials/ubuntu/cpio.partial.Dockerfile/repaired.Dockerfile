RUN apt-get update && \
    apt-get install --no-install-recommends -y cpio && rm -rf /var/lib/apt/lists/*;
