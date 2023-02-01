FROM maven:3-openjdk-17 as builder
WORKDIR /usr/src/app
COPY src/ src/
COPY pom.xml pom.xml
RUN mvn clean package -DskipTests -DskipChecks

FROM azul/zulu-openjdk-alpine:17-jre-headless as starter
USER nobody
CMD java $JAVA_OPTIONS -jar app.jar
COPY --from=builder /usr/src/app/target/starter.jar /app.jar

FROM azul/zulu-openjdk-alpine:17-jre-headless as worker
USER nobody
CMD java $JAVA_OPTIONS -jar app.jar
COPY --from=builder /usr/src/app/target/worker.jar /app.jar
