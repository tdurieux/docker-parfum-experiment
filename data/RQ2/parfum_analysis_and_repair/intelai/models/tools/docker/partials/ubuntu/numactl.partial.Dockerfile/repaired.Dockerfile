RUN apt-get update && \
    apt-get install -y --no-install-recommends --fix-missing numactl && rm -rf /var/lib/apt/lists/*;
