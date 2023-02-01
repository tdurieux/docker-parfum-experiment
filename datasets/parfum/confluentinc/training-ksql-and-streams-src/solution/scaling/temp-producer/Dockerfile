FROM frekele/gradle:latest AS builder
WORKDIR /home/gradle/project
COPY . .
RUN gradle build

FROM openjdk:8-jre
COPY --from=builder /home/gradle/project/build/libs/temp-producer.jar /app.jar
CMD ["java", "-jar", "/app.jar"]
