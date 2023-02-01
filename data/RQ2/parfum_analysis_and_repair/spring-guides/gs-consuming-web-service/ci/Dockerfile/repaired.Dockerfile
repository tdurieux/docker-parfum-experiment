FROM adoptopenjdk/openjdk8:latest

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/*
