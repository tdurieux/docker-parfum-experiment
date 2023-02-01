ARG UBUNTU_VERSION=18.04

FROM ubuntu:$UBUNTU_VERSION as builder
ARG JAVA_VERSION=8

RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9
RUN apt-add-repository 'deb http://repos.azulsystems.com/ubuntu stable main'
RUN apt-get update
RUN apt-get install --no-install-recommends -y zulu-$JAVA_VERSION && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;

ENV JAVA_HOME /usr/lib/jvm/zulu-$JAVA_VERSION-amd64
WORKDIR /work

COPY . /work
RUN make java_test_targets

FROM ubuntu:$UBUNTU_VERSION
ARG JAVA_VERSION=8

RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9
RUN apt-add-repository 'deb http://repos.azulsystems.com/ubuntu stable main'
RUN apt-get update
RUN apt-get install --no-install-recommends -y zre-$JAVA_VERSION && rm -rf /var/lib/apt/lists/*;

WORKDIR /work

COPY --from=builder /work/tests/. /work/tests
COPY tests/run_smoke_test.sh /work/run_smoke_test.sh

ENV JAVA_HOME /usr/lib/jvm/zre-$JAVA_VERSION-amd64
CMD ["/work/run_smoke_test.sh"]
