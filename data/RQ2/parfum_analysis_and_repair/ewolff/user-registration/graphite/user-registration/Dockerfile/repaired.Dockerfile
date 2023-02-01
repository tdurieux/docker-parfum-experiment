FROM ubuntu-update
RUN apt-get install --no-install-recommends -y -qq openjdk-7-jre-headless && rm -rf /var/lib/apt/lists/*;
CMD /usr/bin/java -Dgraphite.enabled=true -Dgraphite.host=graphite -Dgraphite.port=2003 -jar /target/user-registration-application-0.0.1-SNAPSHOT.war
EXPOSE 8080