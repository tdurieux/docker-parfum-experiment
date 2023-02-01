FROM docker.io/library/ubuntu:latest
RUN apt-get update && apt-get -y --no-install-recommends install cargo && rm -rf /var/lib/apt/lists/*;
