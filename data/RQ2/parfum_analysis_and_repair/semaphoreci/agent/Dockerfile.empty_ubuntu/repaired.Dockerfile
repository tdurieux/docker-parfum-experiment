FROM ubuntu:20.04

RUN apt-get update -qy && apt-get install --no-install-recommends -y ca-certificates openssh-client && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates

WORKDIR /app
