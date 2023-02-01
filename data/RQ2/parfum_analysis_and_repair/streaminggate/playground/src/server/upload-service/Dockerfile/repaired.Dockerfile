FROM openjdk:11-jdk
RUN apt-get update && apt upgrade -y \
    && apt-get install --no-install-recommends -y ffmpeg \
    && ffmpeg -version && rm -rf /var/lib/apt/lists/*;
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-Dcom.amazonaws.sdk.disableEc2Metadata=true","-Dspring.profiles.active=develop", "-Dserver.port=50006", "-jar","/app.jar"]