FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

# Bazel
RUN apt-get update
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN curl -f https://storage.googleapis.com/bazel-apt/doc/apt-key.pub.gpg | apt-key add -
RUN apt-get update && apt-get install --no-install-recommends -y bazel && rm -rf /var/lib/apt/lists/*;

# Smyte deps
RUN apt-get install --no-install-recommends -y libssl-dev git python && rm -rf /var/lib/apt/lists/*;

VOLUME /smyte
WORKDIR /smyte
CMD ["/bin/bash"]
