FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y ray && rm -rf /var/lib/apt/lists/*;
