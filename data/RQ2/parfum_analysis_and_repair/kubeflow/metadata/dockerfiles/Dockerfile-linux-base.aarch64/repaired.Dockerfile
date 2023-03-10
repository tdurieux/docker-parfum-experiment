# This file builds the base image for metadata backend server on arm64.

FROM golang:1.12

RUN apt-get update && apt-get -y --no-install-recommends install cmake unzip patch wget && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y unzip build-essential python openjdk-11-jdk protobuf-compiler zip g++ zlib1g-dev && \
    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64 && \
    export JRE_HOME=${JAVA_HOME}/jre && \
    export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib && \
    export PATH=${JAVA_HOME}/bin:$PATH && \
    mkdir /tmp/bazel && \
    cd /tmp/bazel && \
    wget https://github.com/bazelbuild/bazel/releases/download/0.24.1/bazel-0.24.1-dist.zip && \
    unzip bazel-0.24.1-dist.zip && \
    env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh && \
    mkdir /root/bin && \
    cp output/bazel /root/bin/; rm -rf /var/lib/apt/lists/*;

ENV PATH=/root/bin:${PATH}

CMD ["bash"]
