FROM openjdk:8u151-jdk-alpine3.7

EXPOSE 8090

ENV APP_HOME /usr/src/app

COPY target/web-scraper-0.0.1-SNAPSHOT.jar $APP_HOME/app.jar

WORKDIR $APP_HOME

ENTRYPOINT exec java -jar app.jar