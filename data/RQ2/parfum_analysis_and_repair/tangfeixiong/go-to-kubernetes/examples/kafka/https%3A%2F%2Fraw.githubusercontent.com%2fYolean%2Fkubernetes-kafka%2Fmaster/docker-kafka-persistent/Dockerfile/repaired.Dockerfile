FROM openjdk:8u102-jre

ENV kafka_version=0.10.1.1
ENV scala_version=2.11.8
ENV kafka_bin_version=2.11-$kafka_version

RUN curl -f -SLs "https://www.scala-lang.org/files/archive/scala-$scala_version.deb" -o scala.deb \
	&& dpkg -i scala.deb \
	&& rm scala.deb \
	&& curl -f -SLs "https://www.apache.org/dist/kafka/$kafka_version/kafka_$kafka_bin_version.tgz" | tar -xzf - -C /opt \
	&& mv /opt/kafka_$kafka_bin_version /opt/kafka

WORKDIR /opt/kafka
ENTRYPOINT ["bin/kafka-server-start.sh"]

ADD config/server.properties config/

CMD ["config/server.properties"]
