FROM ubuntu:20.04

WORKDIR /root

RUN apt-get update -y && apt-get install --no-install-recommends -y unzip curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://github.com/protocolbuffers/protobuf/releases/download/v3.8.0/protoc-3.8.0-linux-x86_64.zip --output protobuf.zip

RUN unzip protobuf.zip -d protobuf && cp -r protobuf/include/* /usr/local/include/ && cp protobuf/bin/protoc /usr/local/bin/

WORKDIR /

CMD ["bash"]
