### STAGE 1: Build ###

# We label our stage as 'builder'
FROM maven:3.6-jdk-11 as builder

## Storing node modules on a separate layer will prevent unnecessary npm installs at each build
RUN mkdir /seed-springboot

WORKDIR /seed-springboot

COPY . .

## Build the angular app in production mode and store the artifacts in dist folder
RUN mvn package

### STAGE 2: Setup ###