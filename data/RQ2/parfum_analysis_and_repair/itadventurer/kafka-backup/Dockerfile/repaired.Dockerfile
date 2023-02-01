# Build Kafka Backup
FROM gradle:6.3.0-jdk8 AS builder
WORKDIR /opt/kafka-backup
COPY . /opt/kafka-backup
RUN gradle --no-daemon check test shadowJar

# Build Docker Image with Kafka Backup Jar