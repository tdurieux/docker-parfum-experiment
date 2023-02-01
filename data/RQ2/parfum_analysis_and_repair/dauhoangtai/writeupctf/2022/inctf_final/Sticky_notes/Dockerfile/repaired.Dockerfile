FROM openjdk:11-jdk-stretch
RUN apt-get update && apt-get -y --no-install-recommends install netcat && apt-get clean && rm -rf /var/lib/apt/lists/*;
COPY deployment /usr/src/sticky_notes
WORKDIR /usr/src/sticky_notes
CMD ["java", "-jar","Sticky_notes.jar"]