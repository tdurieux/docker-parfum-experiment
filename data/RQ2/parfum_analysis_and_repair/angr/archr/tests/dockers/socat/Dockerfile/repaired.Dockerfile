from ubuntu:focal

RUN apt-get update -y && apt-get install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;

entrypoint []

cmd socat tcp-l:1337,reuseaddr exec:cat
expose 1337
