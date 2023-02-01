FROM ubuntu:18.04

LABEL email="ssangyu123@gmail.com"
LABEL name="sakjung"
LABEL description="zzimkkong main application"

RUN apt-get -y update && apt-get install --no-install-recommends -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;

# run application
WORKDIR /home/ubuntu
COPY build/libs/backend-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 	8080

ENTRYPOINT ["java", "-Dspring.profiles.active=prod", "-jar", "app.jar", "--spring.config.location=classpath:config/application-prod.properties"]
