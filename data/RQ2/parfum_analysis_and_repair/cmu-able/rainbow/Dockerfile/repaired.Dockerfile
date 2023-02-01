FROM maven:3-jdk-8
#----
# Install Maven
RUN apt-get install --no-install-recommends -y tar gzip && rm -rf /var/lib/apt/lists/*;
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
# speed up Maven JVM a bit
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
ENTRYPOINT ["/root/rainbow/build.sh", "-d", "/root/rainbow/"]

