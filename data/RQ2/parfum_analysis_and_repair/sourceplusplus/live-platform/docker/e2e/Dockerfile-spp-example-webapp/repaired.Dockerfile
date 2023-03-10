FROM openjdk:11-jre
ADD ./example-web-app/build/distributions/example-jvm-boot-1.0-SNAPSHOT.zip /example-jvm-boot-1.0-SNAPSHOT.zip

RUN mkdir /tmp/spp-probe
ADD ./spp-probe.yml /tmp/spp-probe
ADD ./spp-probe-*.jar /tmp/spp-probe/spp-probe.jar

#ENV JAVA_OPTS="-javaagent:/tmp/spp-probe/spp-probe.jar"
ENV JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5105 -javaagent:/tmp/spp-probe/spp-probe.jar"

RUN unzip *.zip
CMD ["./example-jvm-boot-1.0-SNAPSHOT/bin/example-jvm"]