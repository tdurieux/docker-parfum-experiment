FROM debian:jessie

# Use Java 8 backport
RUN echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list

RUN apt-get update

RUN apt-get -y --no-install-recommends install build-essential clang llvm cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -t jessie-backports ca-certificates-java && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openjdk-8-jdk ant && rm -rf /var/lib/apt/lists/*;

# Select Java 8
RUN update-java-alternatives -s java-1.8.0-openjdk-amd64
RUN rm -f /usr/lib/jvm/default-java
RUN ln -s /usr/lib/jvm/java-8-openjdk-amd64 /usr/lib/jvm/default-java

ENV CXX clang++

VOLUME /opt/djinni
CMD /opt/djinni/test-suite/java/docker/build_and_run_tests.sh

