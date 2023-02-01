FROM openjdk:8-slim

# Git is needed in order to update the dls submodule
RUN apt-get update && apt-get install --no-install-recommends -y wget protobuf-compiler git && rm -rf /var/lib/apt/lists/*;

RUN mkdir /temporal-java-samples
WORKDIR /temporal-java-samples
