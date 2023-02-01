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
RUN apt-get install --no-install-recommends -y python3-minimal python3-pip && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install pip --upgrade
RUN python3 -m pip install tox

WORKDIR /work

COPY --from=builder /work/tests/. /work/tests
COPY --from=builder /work/Makefile /work/Makefile
COPY --from=builder /work/tox.ini /work/tox.ini
COPY tests/run_tests.sh /work/run_tests.sh

ENV JAVA_HOME /usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64
# This should get mounted in if we want to use it
ENV AGENT_DIR /work/build/

CMD ["/work/run_tests.sh"]
