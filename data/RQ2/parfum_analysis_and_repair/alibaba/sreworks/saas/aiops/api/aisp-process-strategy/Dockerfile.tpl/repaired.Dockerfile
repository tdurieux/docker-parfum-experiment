FROM {{ MAVEN_IMAGE }} AS build
COPY . /app
RUN mkdir /root/.m2/ && curl -f {{ MAVEN_SETTINGS_XML }} -o /root/.m2/settings.xml
RUN cd /app && mvn -f pom.xml -Dmaven.test.skip=true clean package

FROM {{ JRE11_IMAGE }} AS release
ARG START_MODULE=aisp-process-strategy-start
ARG JAR_NAME=aisp-process-strategy.jar
ARG BUILD_JAR=/app/${START_MODULE}/target/aisp-process-strategy.jar

COPY --from=build ${BUILD_JAR} /app/${JAR_NAME}
COPY ./sbin/ /app/sbin/
COPY ./${START_MODULE}/src/main/resources/application.properties /app/application.properties

ENTRYPOINT ["/app/sbin/run.sh"]