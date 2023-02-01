FROM gcr.io/google_appengine/nodejs
ADD swarm-client.jar /lib/
RUN apt-get -y update && apt-get -y --no-install-recommends install git openjdk-7-jre openjdk-7-jdk wget libpng-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["java", "-jar", "/lib/swarm-client.jar", "-disableSslVerification", "-master", "http://jenkins:8080", "-labels", "nodejs-slave", "-executors", "1"]
