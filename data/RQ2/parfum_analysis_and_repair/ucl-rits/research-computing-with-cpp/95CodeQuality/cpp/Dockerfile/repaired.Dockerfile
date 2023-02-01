FROM ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends -y cmake valgrind gcc g++ libeigen3-dev && rm -rf /var/lib/apt/lists/*;
