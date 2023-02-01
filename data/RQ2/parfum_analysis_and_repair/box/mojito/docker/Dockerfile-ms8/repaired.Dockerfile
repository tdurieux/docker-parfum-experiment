FROM maven:3.5.4-jdk-8 as build
RUN apt-get update && apt-get install --no-install-recommends -y build-essential python nodejs-legacy libpng-dev pngquant && rm -rf /var/lib/apt/lists/*;
VOLUME ["/tmp"]

WORKDIR /mnt/mojito

# The is to avoid re-downloading dependencies every single time
COPY ./pom.xml /mnt/mojito/pom.xml
COPY ./cli/pom.xml /mnt/mojito/cli/pom.xml
COPY ./common/pom.xml /mnt/mojito/common/pom.xml
COPY ./mavenplugin/pom.xml /mnt/mojito/mavenplugin/pom.xml
COPY ./restclient/pom.xml /mnt/mojito/restclient/pom.xml
COPY ./test-common/pom.xml /mnt/mojito/test-common/pom.xml
COPY ./webapp/pom.xml /mnt/mojito/webapp/pom.xml
RUN mvn dependency:go-offline -B

# copy source and make sure node* are not present (Mac version may conflict with Linux)
COPY . /mnt/mojito
RUN rm -rf /mnt/mojito/webapp/node/ /mnt/mojito/webapp/node_modules

ENV PATH="/mnt/mojito/webapp/node/:${PATH}"
RUN mvn install -DskipTests

FROM openjdk:8-alpine
VOLUME /tmp
COPY --from=build /mnt/mojito/webapp/target/mojito-webapp-*-exec.jar mojito-webapp.jar
COPY --from=build /mnt/mojito/cli/target/mojito-cli-*-exec.jar mojito-cli.jar
RUN sh -c 'touch /mojito-webapp.jar'
RUN sh -c 'touch /mojito-cli.jar'
# starting with "exec doesn't seem to be needed with openjdk:8-alpine. As per docker documentation, it is required in general
ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /mojito-webapp.jar
