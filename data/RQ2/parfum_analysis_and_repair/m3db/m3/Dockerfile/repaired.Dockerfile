FROM golang:1.18-stretch

RUN apt-get update && apt-get install --no-install-recommends -y lsof && rm -rf /var/lib/apt/lists/*;
