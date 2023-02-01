FROM openjdk:11
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar /app.jar"]
HEALTHCHECK CMD [ curl -sf 'https://localhost:8080/actuator/health' >/dev/null || exit 1]
