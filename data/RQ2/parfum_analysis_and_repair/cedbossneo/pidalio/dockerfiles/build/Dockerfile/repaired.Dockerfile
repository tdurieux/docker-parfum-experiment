FROM golang:1.6

RUN apt-get update && apt-get install --no-install-recommends -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*;
