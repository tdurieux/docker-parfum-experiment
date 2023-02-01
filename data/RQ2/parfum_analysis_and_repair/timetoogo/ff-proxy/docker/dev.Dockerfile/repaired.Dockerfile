FROM ubuntu:latest

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends install -y \
    git-core valgrind g++ clang nano libssl-dev build-essential && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
