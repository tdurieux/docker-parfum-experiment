# Build and run with:
#
# $ docker build -t accp -f Dockerfile.dev .
# $ docker run -v $(pwd):/accp --rm -it accp:latest
#
# Once in the container's shell, quickly iterate on rebuilding AWS-LC and ACCP
# to re-run a single test with:
#
# $ SINGLE_TEST=com.amazon.corretto.crypto.provider.test.EvpSignatureTest
# $ ./gradlew minimal_clean && ./gradlew single_test -DSINGLE_TEST=${SINGLE_TEST}


FROM ubuntu:20.04

# install corretto JDK
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://apt.corretto.aws/corretto.key | apt-key add -
RUN echo 'deb https://apt.corretto.aws stable main' | tee /etc/apt/sources.list.d/corretto.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y java-11-amazon-corretto-jdk && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto/
RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto/' >> /home/.bashrc

# required dependencies for building/testing
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y dieharder && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y lcov && rm -rf /var/lib/apt/lists/*;

# developement niceties
RUN apt-get install --no-install-recommends -y ninja-build && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN mkdir /accp
COPY . /accp
WORKDIR /accp

# run the gradlew script just to install gradle in the image
RUN ./gradlew --no-daemon generateEclipseClasspath

ENTRYPOINT /bin/bash
