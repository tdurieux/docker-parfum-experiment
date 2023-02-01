FROM ubuntu:latest

RUN apt-get update -y && apt-get install --no-install-recommends python3 -y && rm -rf /var/lib/apt/lists/*;