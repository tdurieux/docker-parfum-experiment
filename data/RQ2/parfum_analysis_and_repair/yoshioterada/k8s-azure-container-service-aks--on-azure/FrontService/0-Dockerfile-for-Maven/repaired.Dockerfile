FROM maven:3.6.1-jdk-8-slim 
COPY src /usr/src/app/src  
COPY pom.xml /usr/src/app  
RUN mvn -f /usr/src/app/pom.xml package
RUN rm -rf src pom.xml