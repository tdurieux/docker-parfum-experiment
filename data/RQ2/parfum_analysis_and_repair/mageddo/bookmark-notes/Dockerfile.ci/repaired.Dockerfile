FROM debian:10

RUN apt-get update -y && apt-get install --no-install-recommends -y git curl build-essential zlib1g-dev jq && rm -rf /var/lib/apt/lists/*;

ENV GRAALVM_DOWNLOAD_URL=https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-19.3.0/graalvm-ce-java11-linux-amd64-19.3.0.tar.gz
ENV GRAALVM_TARGET_DIR="/"
ENV GRAALVM_TARGET_FILE="/tmp/graalvm-ce-19.3.0-amd64.tar.gz"

WORKDIR ${GRAALVM_TARGET_DIR}
RUN curl -f -L ${GRAALVM_DOWNLOAD_URL} > ${GRAALVM_TARGET_FILE} && \
  tar -xf ${GRAALVM_TARGET_FILE} -C ${GRAALVM_TARGET_DIR} && \
  curl -f -s -L https://github.com/mageddo-projects/github-cli/releases/download/v1.4/github-cli.sh > /usr/bin/github-cli && \
  chmod +x /usr/bin/github-cli && \
  rm -r /tmp/*

ENV _JAVA_HOME="/graalvm-ce-java11-19.3.0"
RUN ${_JAVA_HOME}/bin/gu install native-image
ADD src/main/docker/ci/entrypoint.sh /entrypoint.sh

WORKDIR /app
ENTRYPOINT /entrypoint.sh
