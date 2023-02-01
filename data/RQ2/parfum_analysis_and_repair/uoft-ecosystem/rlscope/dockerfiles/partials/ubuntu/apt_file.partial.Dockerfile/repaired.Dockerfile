RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-file && rm -rf /var/lib/apt/lists/*;
RUN apt-file update

