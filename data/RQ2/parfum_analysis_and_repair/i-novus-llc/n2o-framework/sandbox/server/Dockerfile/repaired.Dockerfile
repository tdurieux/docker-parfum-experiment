FROM adoptopenjdk/openjdk14:alpine-slim

LABEL maintainer="iryabov@i-novus.ru"

RUN apk add --no-cache tzdata
ENV TZ=Europe/Moscow

EXPOSE 8080

COPY target/sandbox.jar n2o-sandbox.jar
ENTRYPOINT ["java","-jar","n2o-sandbox.jar"]