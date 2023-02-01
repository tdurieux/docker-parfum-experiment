FROM java:8
MAINTAINER HealerJean
ADD target/com-hlj-springboot-docker-0.0.1-SNAPSHOT.jar app.jar
CMD ["java","-jar","/app.jar"]