FROM openjdk:11-slim

# Git is needed in order to update the dls submodule
RUN apt-get update && apt-get install --no-install-recommends -y protobuf-compiler git && rm -rf /var/lib/apt/lists/*;

RUN mkdir /temporal-java-client
WORKDIR /temporal-java-client
