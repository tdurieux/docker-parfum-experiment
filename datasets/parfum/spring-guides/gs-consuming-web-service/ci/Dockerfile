FROM adoptopenjdk/openjdk8:latest

RUN apt-get update && apt-get install -y git

RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/*
