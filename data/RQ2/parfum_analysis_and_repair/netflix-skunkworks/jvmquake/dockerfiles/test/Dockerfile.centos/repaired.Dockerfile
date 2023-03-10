ARG CENTOS_VERSION=7

FROM centos:$CENTOS_VERSION as builder
ARG JAVA_VERSION=1.8.0

RUN yum update -y
RUN yum install -y java-$JAVA_VERSION-openjdk-devel && rm -rf /var/cache/yum
RUN yum install -y make && rm -rf /var/cache/yum
ENV JAVA_HOME /usr/lib/jvm/java-$JAVA_VERSION-openjdk/
WORKDIR /work

COPY . /work
RUN make java_test_targets

FROM centos:$CENTOS_VERSION
ARG JAVA_VERSION=1.8.0

RUN yum update -y
RUN yum install -y java-$JAVA_VERSION-openjdk-headless && rm -rf /var/cache/yum
RUN yum install -y python3 && rm -rf /var/cache/yum

RUN python3 -m pip install pip --upgrade
RUN python3 -m pip install tox

WORKDIR /work

COPY --from=builder /work/tests/. /work/tests
COPY --from=builder /work/Makefile /work/Makefile
COPY --from=builder /work/tox.ini /work/tox.ini
COPY tests/run_tests.sh /work/run_tests.sh

ENV JAVA_HOME /usr/lib/jvm/jre-$JAVA_VERSION-openjdk/
# This should get mounted in if we want to use it
ENV AGENT_DIR /work/build/

CMD ["/work/run_tests.sh"]
