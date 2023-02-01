FROM jenkins/jnlp-slave

USER root

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://ftp.de.debian.org/debian sid main" >> /etc/apt/sources.list && \
    apt-get update && \

    apt-get install --no-install-recommends -o APT::Immediate-Configure=0 -y curl gnupg && \

    curl -f -Lo /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.7.4/bazelisk-linux-amd64 && \
    chown root:root /usr/local/bin/bazel && \
    chmod 0755 /usr/local/bin/bazel && \
    bazel version && \

    apt-get install --no-install-recommends -y maven && \

    apt-get install --no-install-recommends -y clang-format-11 && \
    cp /usr/bin/clang-format-11 /usr/bin/clang-format && \

    apt-get upgrade -y zlib1g && \
    apt-get install --no-install-recommends -y npm && \
    npm install --global prettier && \

    apt-get install --no-install-recommends -y wget unzip && \
    wget https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protoc-3.7.1-linux-x86_64.zip && \
    unzip protoc-3.7.1-linux-x86_64.zip -d /opt/protobuf && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

RUN BIN="/usr/local/bin" && \
    VERSION="0.12.1" && \
    BINARY_NAME="buf" && \
      curl -f -sSL \
        "https://github.com/bufbuild/buf/releases/download/v${VERSION}/${BINARY_NAME}-$(uname -s)-$(uname -m)" \
        -o "${BIN}/${BINARY_NAME}" && \
      chmod +x "${BIN}/${BINARY_NAME}"

ENV PATH ${PATH}:/opt/protobuf/bin

