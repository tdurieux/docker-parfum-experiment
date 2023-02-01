ARG UBUNTU_VERSION=18.04

FROM ubuntu:$UBUNTU_VERSION as builder
ARG JAVA_VERSION=8

RUN apt-get update
RUN apt-get install --no-install-recommends -y openjdk-$JAVA_VERSION-jdk-headless && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;

ENV JAVA_HOME /usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64
WORKDIR /work

COPY . /work
RUN make java_test_targets

FROM ubuntu:$UBUNTU_VERSION
ARG JAVA_VERSION=8

RUN apt-get update
RUN apt-get install --no-install-recommends -y openjdk-$JAVA_VERSION-jre-headless && rm -rf /var/lib/apt/lists/*;

WORKDIR /work

COPY --from=builder /work/tests/. /work/tests
COPY tests/run_smoke_test.sh /work/run_smoke_test.sh

ENV JAVA_HOME /usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64
CMD ["/work/run_smoke_test.sh"]
