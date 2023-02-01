FROM ubuntu:latest

RUN apt-get update -y && apt-get install --no-install-recommends -y haskell-platform && rm -rf /var/lib/apt/lists/*;