FROM maven:3.6.3-jdk-11-slim
# Update apt-get and install iptables
RUN apt-get update && apt-get install --no-install-recommends -y iptables git && rm -rf /var/lib/apt/lists/*;
# Add pom and checkstyle suppressions to cache dependencies
WORKDIR /tmp/java
COPY pom.xml .
COPY checkstyle/suppressions.xml /tmp/java/checkstyle/suppressions.xml
COPY checkstyle.xml /tmp/java/checkstyle.xml
RUN  mvn verify --fail-never
# Copy in java src code
COPY src/ /tmp/java/src/
