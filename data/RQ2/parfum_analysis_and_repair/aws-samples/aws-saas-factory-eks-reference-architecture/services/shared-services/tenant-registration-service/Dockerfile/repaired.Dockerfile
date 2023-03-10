FROM maven:3.6.3-amazoncorretto-11 as BUILD

#ADD m2.tar.gz /root

COPY . /usr/src/tenant-registration-service
RUN mvn -Dmaven.repo.local=/root/m2 --batch-mode -f /usr/src/tenant-registration-service/pom.xml clean package

FROM openjdk:11-jdk-slim
EXPOSE 80
COPY --from=BUILD /usr/src/tenant-registration-service/target /opt/target
WORKDIR /opt/target

CMD ["java", "-jar", "tenant-registration-service.war"]