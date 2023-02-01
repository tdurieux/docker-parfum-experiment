FROM debian:buster-slim
RUN apt-get update && apt-get -y upgrade && apt-get install --no-install-recommends -y git build-essential clang valgrind \
    && mkdir -m 666 /project && rm -rf /var/lib/apt/lists/*;
WORKDIR /project