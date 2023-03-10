FROM openjdk:8-jdk-slim as builder

ENV APP_HOME /app

COPY pom.xml $APP_HOME/
COPY proto $APP_HOME/proto
COPY tracedsl $APP_HOME/tracedsl
COPY spark $APP_HOME/spark
COPY testcontainers $APP_HOME/testcontainers
COPY .mvn $APP_HOME/.mvn
COPY mvnw $APP_HOME/

WORKDIR $APP_HOME
RUN ./mvnw package -DskipTests

FROM openjdk:8-jre-slim
MAINTAINER Pavol Loffay <ploffay@redhat.com>
ENV APP_HOME /app
COPY --from=builder $APP_HOME/spark/target/jaeger-spark-*.jar $APP_HOME/

WORKDIR $APP_HOME

COPY entrypoint.sh /

RUN chgrp root /etc/passwd && chmod g+rw /etc/passwd
USER 185

ENTRYPOINT ["/entrypoint.sh"]
CMD java ${JAVA_OPTS} -jar $APP_HOME/jaeger-spark-*.jar