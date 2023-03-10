# This ARG isn't used but prevents warnings in the build script
ARG CODE_VERSION
FROM openjdk:8-jdk

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

# First set up maven
ARG MAVEN_VERSION=3.5.0
ARG SHA=beb91419245395bd69a4a6edad5ca3ec1a8b64e41457672dc687c173a495f034
ARG BASE_URL=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
  && apt-get update \
  && apt-get install --no-install-recommends -y libzmq5 libzmq3-dev git pkg-config libtool autoconf g++ make \
  && git clone https://github.com/zeromq/jzmq.git /root/jzmq \
  && cd /root/jzmq/jzmq-jni \
  && ./autogen.sh \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && make install && rm -rf /var/lib/apt/lists/*;


ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG /root/.m2

COPY ./containers/jvm/ /root/container

WORKDIR /root/container

RUN mkdir -p /model \
      && cd /root/container \
      && mvn clean package -DskipTests

ENV CLIPPER_MODEL_PATH=/model

CMD ["java", "-Djava.library.path=/usr/local/lib", "-Xmx512m", "-cp", "/root/container/spark-container-impl/target/spark-container-impl-0.1.jar", "ai.clipper.spark.container.impl.ContainerMain"]

HEALTHCHECK --interval=3s --timeout=3s --retries=1 CMD test -f /model_is_ready.check || exit 1
# vim: set filetype=dockerfile:
