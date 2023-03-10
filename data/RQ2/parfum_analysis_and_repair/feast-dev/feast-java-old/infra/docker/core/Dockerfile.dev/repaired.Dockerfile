FROM openjdk:11-jre
ARG REVISION=dev
ADD $PWD/core/target/feast-core-$REVISION-exec.jar /opt/feast/feast-core.jar
CMD ["java",\
     "-Xms2048m",\
     "-Xmx2048m",\
     "-jar",\
     "/opt/feast/feast-core.jar"]