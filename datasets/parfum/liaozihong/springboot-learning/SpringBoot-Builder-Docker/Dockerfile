FROM openjdk:8
LABEL maintainer="15017263266@163.com"
WORKDIR /
ARG JAR_FILE
ADD ${JAR_FILE} app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
