# docker build . -t publicawesome/golang:1.18.3-devtooling -f docker/Dockerfile.go-devtools
FROM golang:1.18.3
RUN apt-get update && \
  apt-get install --no-install-recommends -y cmake && \
  apt-get -y clean && \
  rm -rf /var/lib/apt/lists/*
