FROM tensorflow/tensorflow:1.4.0
WORKDIR /
RUN apt-get update && apt-get -y --no-install-recommends install maven openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
RUN mvn dependency:get -Dartifact=org.tensorflow:tensorflow:1.4.0
RUN mvn dependency:get -Dartifact=org.tensorflow:proto:1.4.0
CMD ["/bin/bash", "-l"]
