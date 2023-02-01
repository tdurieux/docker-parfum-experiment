# initialize from the image

FROM debian:9

# install build tools and dependencies

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential curl unzip git python3 python3-pip \
    libsdl2-dev libsdl2-image-dev && rm -rf /var/lib/apt/lists/*;

ENV PROTOBUF_VERSION=3.4.0
RUN curl -f -LO "https://github.com/google/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip"
RUN unzip "protoc-${PROTOBUF_VERSION}-linux-x86_64.zip" -d /usr
RUN pip3 install --no-cache-dir "protobuf==${PROTOBUF_VERSION}" ecdsa

RUN ln -s python3 /usr/bin/python
