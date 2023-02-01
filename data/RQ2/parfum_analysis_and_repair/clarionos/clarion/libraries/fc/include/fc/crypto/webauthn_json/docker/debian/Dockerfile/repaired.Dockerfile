# BUILD:  docker build -t rapidjson-debian .
# RUN:    docker run -it -v "$PWD"/../..:/rapidjson rapidjson-debian

FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y g++ cmake doxygen valgrind && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/bin/bash"]
