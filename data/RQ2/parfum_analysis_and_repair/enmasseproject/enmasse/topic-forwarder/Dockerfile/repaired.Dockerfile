FROM quay.io/enmasse/java-base:11-5

ARG version
ARG maven_version
ARG revision
ENV VERSION=${version} REVISION=${revision} MAVEN_VERSION=${maven_version}
ADD target/topic-forwarder-${maven_version}.jar /topic-forwarder.jar

CMD ["/opt/run-java/launch_java.sh", "-jar", "/topic-forwarder.jar"]