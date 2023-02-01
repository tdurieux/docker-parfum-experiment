FROM debian:jessie-slim

RUN mkdir -p /src/nscp
ADD . /src/nscp/
RUN apt-get update && apt-get upgrade -y
RUN apt-get update
RUN apt-get install --no-install-recommends -y git build-essential debhelper cmake python-dev libssl-dev libboost-all-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libprotobuf-dev libcrypto++-dev libgtest-dev liblua5.1-0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y protobuf-compiler python-protobuf python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir jinja2 mkdocs

RUN mkdir -p /src/build


