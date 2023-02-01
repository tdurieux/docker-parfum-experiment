FROM ubuntu

RUN apt-get update && \
    apt-get -y --no-install-recommends install gcc valgrind time python && rm -rf /var/lib/apt/lists/*;
