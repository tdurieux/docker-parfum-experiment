#FROM tomcat:9.0.31-jdk11-openjdk
#From tomcat:8.0.51-jre8-alpine
#ADD ./target/example01-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ctf.war
#EXPOSE 8080
#CMD ["catalina.sh","run"]

#FROM openjdk:8-jdk-alpine
#ARG JAR_FILE=target/gs-spring-boot-docker-0.1.0.jar
#COPY ${JAR_FILE} app.jar
#ENTRYPOINT ["java","-jar","/app.jar"]