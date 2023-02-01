FROM debian

RUN apt-get update && apt-get install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;
