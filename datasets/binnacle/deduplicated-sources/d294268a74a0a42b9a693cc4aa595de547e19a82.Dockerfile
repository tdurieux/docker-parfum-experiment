FROM ubuntu:xenial

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install openjdk-8-jre-headless -qqy --no-install-recommends

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

COPY vendor/UnlimitedJCEPolicyJDK8/local_policy.jar ${JAVA_HOME}/jre/lib/security/local_policy.jar
COPY vendor/UnlimitedJCEPolicyJDK8/US_export_policy.jar ${JAVA_HOME}/jre/lib/security/US_export_policy.jar
