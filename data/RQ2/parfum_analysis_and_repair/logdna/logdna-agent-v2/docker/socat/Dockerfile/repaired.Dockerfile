FROM buildpack-deps:bullseye-curl

RUN apt update && apt install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;
