FROM java:openjdk-8u91-jdk
CMD java ${JAVA_OPTS} -jar board-command-side-service.jar
COPY build/libs/board-command-side-service.jar .