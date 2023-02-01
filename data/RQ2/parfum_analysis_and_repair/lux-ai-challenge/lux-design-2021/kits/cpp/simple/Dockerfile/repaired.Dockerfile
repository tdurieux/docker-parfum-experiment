FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends g++ -y && rm -rf /var/lib/apt/lists/*;