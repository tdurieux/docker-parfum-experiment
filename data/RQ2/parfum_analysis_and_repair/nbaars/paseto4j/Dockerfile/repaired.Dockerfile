FROM openjdk:11.0.11-slim-buster


RUN apt-get update && apt-get -y --no-install-recommends install libsodium-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /workspace