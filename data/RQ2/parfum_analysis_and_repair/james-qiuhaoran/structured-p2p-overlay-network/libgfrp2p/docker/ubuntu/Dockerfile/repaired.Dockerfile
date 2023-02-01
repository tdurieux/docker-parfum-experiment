FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y build-essential cmake libprotobuf-dev libprotobuf10 protobuf-compiler && rm -rf /var/lib/apt/lists/*;