FROM debian:latest
RUN apt update && apt upgrade && apt -y --no-install-recommends install openjdk-17-jdk-headless && apt install --no-install-recommends -y ghostscript && rm -rf /var/lib/apt/lists/*;
COPY target/esup-signature.war esup-signature.war
COPY src/main/resources/application-docker.yml /tmp/application-docker.yml
ENTRYPOINT ["java","-jar","/esup-signature.war","--spring.config.location=file:/tmp/application-docker.yml"]