FROM ubuntu:bionic

RUN apt-get update && apt-get install --no-install-recommends --yes python3 && rm -rf /var/lib/apt/lists/*;

COPY . .
RUN ./postBuild
