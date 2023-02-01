FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y curl && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

