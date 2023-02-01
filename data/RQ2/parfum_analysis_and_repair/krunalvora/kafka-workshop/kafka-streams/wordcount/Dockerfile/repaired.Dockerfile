# select image
FROM maven:3.6-jdk-8-slim

# copy your source tree
COPY ./ ./

# build for release
RUN mvn clean package

# set the startup command to run your binary