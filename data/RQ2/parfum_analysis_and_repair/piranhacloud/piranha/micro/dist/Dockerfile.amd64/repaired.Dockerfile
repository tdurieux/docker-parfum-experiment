FROM eclipse-temurin:17
RUN mkdir /usr/local/piranha
ADD target/piranha-micro.jar /usr/local/piranha
WORKDIR /usr/local/piranha
CMD ["java", "-jar", "piranha-micro.jar"]