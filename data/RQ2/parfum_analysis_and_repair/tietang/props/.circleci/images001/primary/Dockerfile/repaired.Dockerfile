FROM golang:1.10.3
FROM openjdk:8u171-jdk-browsers

RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
