FROM openjdk:8-jdk-alpine
ADD target/com.manning.mss.appendixe.sample01-1.0.0.jar com.manning.mss.appendixe.sample01-1.0.0.jar
ENV SPRING_CONFIG_LOCATION=/opt/application.properties
ENTRYPOINT ["java", "-jar", \
"com.manning.mss.appendixe.sample01-1.0.0.jar"]