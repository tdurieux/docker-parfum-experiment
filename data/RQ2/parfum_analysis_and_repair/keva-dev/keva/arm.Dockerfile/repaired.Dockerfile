FROM openjdk:11 AS builder
RUN mkdir -p /root/src/keva
WORKDIR /root/src/keva

COPY gradle ./gradle
COPY build.gradle gradlew settings.gradle ./
COPY ./app/build.gradle ./app/keva.properties ./app/
RUN ./gradlew dependencies

COPY . .
RUN ./gradlew :app:build -x test

FROM eclipse-temurin:11.0.13_8-jdk-centos7
RUN mkdir -p /root/binary/keva
WORKDIR /root/binary/keva

COPY --from=builder /root/src/keva/app/build/libs/app-*.jar /root/binary/keva/keva.jar

EXPOSE 6379

ENTRYPOINT ["java","-jar","-Xms24m","keva.jar"]

# docker build -f arm.Dockerfile -t keva-server:1.0.0-rc2-arm .
# docker run -d --name keva-server -p 6767:6379 keva-server:latest