FROM tomcat:9.0-jre11-temurin-focal
RUN curl -f -O https://open-install-library-artifacts.s3.us-west-2.amazonaws.com/linux/java/spring-boot-rest.war
COPY spring-boot-rest.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]