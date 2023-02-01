## Build stage
FROM maven:latest AS builder
COPY app/ /
RUN cd CustomerOrderServicesProject && mvn clean package

## Application image