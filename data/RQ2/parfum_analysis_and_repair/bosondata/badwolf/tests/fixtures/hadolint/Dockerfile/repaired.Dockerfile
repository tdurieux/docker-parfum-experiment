FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends file && rm -rf /var/lib/apt/lists/*;
