FROM ubuntu:utopic-20150625

RUN apt-get update
RUN apt-get -y --no-install-recommends install build-essential clang cmake && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y openjdk-8-jdk ant && rm -rf /var/lib/apt/lists/*;

ENV CXX clang++

# Select Java 8
RUN update-java-alternatives -s java-1.8.0-openjdk-amd64
RUN rm /usr/lib/jvm/default-java
RUN ln -s /usr/lib/jvm/java-8-openjdk-amd64 /usr/lib/jvm/default-java

VOLUME /opt/djinni
CMD /opt/djinni/test-suite/java/docker/build_and_run_tests.sh

