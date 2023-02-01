FROM golang:1.13.8
RUN apt-get update && apt-get install --no-install-recommends -y pandoc && rm -rf /var/lib/apt/lists/*;