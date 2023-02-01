FROM ubuntu:20.04
RUN apt update && apt install --no-install-recommends openjdk-11-jre-headless -y && rm -rf /var/lib/apt/lists/*;
COPY target/simplecode-0.0.1-SNAPSHOT.jar /opt/app.jar
CMD ["java","-jar","/opt/app.jar"]

