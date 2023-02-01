#Step-1
FROM gradle:7.3.3-jdk17 AS TEMP_BUILD_IMAGE
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle build --no-daemon
#Step-2
FROM openjdk:17-jdk
ENV ARTIFACT_NAME=malwarescan-lib-1.0.0.jar
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME
COPY --from=TEMP_BUILD_IMAGE /home/gradle/src/malwarescan-lib/build/libs/$ARTIFACT_NAME $ARTIFACT_NAME

EXPOSE 7171
CMD java -jar $ARTIFACT_NAME