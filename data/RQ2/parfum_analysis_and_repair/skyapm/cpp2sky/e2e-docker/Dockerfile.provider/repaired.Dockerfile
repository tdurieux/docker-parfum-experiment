FROM ubuntu:18.04
RUN apt-get update && apt install --no-install-recommends -y wget build-essential clang && rm -rf /var/lib/apt/lists/*;
RUN wget -O /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64
RUN chmod +x /usr/local/bin/bazel
COPY . /tmp
WORKDIR tmp
RUN bazel build //test/e2e:e2e_provider
