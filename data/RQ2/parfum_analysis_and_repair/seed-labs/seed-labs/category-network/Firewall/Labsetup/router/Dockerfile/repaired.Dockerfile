FROM handsonsecurity/seed-ubuntu:large

RUN apt-get update \
    && apt-get install --no-install-recommends -y kmod \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;
