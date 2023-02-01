FROM handsonsecurity/seed-ubuntu:small

RUN apt-get update && apt-get install --no-install-recommends -y \
        build-essential \
        libssl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;
