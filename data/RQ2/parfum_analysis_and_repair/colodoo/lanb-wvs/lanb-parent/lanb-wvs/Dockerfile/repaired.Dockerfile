FROM carsharing/alpine-oraclejdk8-bash

COPY target/lanb-wvs-1.0-SNAPSHOT.jar app.jar

ENTRYPOINT ["java","-jar","/app.jar"]