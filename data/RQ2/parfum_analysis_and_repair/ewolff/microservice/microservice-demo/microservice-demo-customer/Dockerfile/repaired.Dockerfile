FROM openjdk:11.0.2-jre-slim
COPY target/microservice-demo-customer-0.0.1-SNAPSHOT.jar .
CMD /usr/bin/java -Xmx400m -Xms400m -jar microservice-demo-customer-0.0.1-SNAPSHOT.jar
EXPOSE 8080