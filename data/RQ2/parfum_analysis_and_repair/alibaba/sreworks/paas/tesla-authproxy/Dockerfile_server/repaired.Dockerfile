FROM reg.docker.alibaba-inc.com/abm-aone/maven_auth AS build
COPY . /app
RUN cd /app && mvn -f pom_private.xml -Dmaven.test.skip=true clean package

FROM reg.docker.alibaba-inc.com/abm-aone/openjdk8-jre AS release
ARG START_MODULE=tesla-authproxy-start
ARG TARGET_DIRECTORY=tesla-authproxy-service
ARG JAR_NAME=tesla-authproxy.jar
ARG BUILD_JAR=/app/${START_MODULE}/target/tesla-authproxy-start-2.0.1.jar

COPY --from=build ${BUILD_JAR} /app/${JAR_NAME}
COPY ./sbin/ /app/sbin/
COPY ./${START_MODULE}/src/main/resources/application-docker.properties /app/application.properties
RUN apk add --update --no-cache gettext
ENTRYPOINT ["/app/sbin/run.sh"]