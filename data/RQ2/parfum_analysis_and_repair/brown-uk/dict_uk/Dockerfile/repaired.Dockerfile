FROM ubuntu:20.04

RUN apt update && apt install --no-install-recommends -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;
ADD . /src
WORKDIR /src
RUN ./gradlew expand
