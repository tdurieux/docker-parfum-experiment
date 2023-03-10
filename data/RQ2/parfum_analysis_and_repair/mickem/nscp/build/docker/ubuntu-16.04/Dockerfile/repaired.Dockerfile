FROM ubuntu:16.04

RUN mkdir -p /src/nscp
ADD . /src/nscp/
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y git build-essential debhelper cmake python-dev libssl-dev libboost-all-dev libprotobuf-dev libcrypto++-dev libgtest-dev liblua5.1-0-dev protobuf-compiler python-protobuf python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir jinja2 mkdocs

RUN mkdir -p /src/build


