FROM debian
RUN apt-get update && apt-get install --no-install-recommends -y \
    nano \
    siege && rm -rf /var/lib/apt/lists/*;
