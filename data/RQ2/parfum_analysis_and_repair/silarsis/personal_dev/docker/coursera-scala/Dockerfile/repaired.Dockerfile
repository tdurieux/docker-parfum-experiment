FROM silarsis/base
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get -yq update && apt-get -yq --no-install-recommends install openjdk-7-jdk && rm -rf /var/lib/apt/lists/*;
RUN wget -q -O /tmp/sbt.tgz https://scalasbt.artifactoryonline.com/scalasbt/sbt-native-packages/org/scala-sbt/sbt/0.12.4/sbt.tgz \
  && cd /usr/local \
  && tar zxf /tmp/sbt.tgz && rm /tmp/sbt.tgz
ENV PATH $PATH:/usr/local/sbt/bin

VOLUME /opt/progfun
WORKDIR /opt/progfun
RUN /usr/local/sbt/bin/sbt version
CMD ["sbt"]
