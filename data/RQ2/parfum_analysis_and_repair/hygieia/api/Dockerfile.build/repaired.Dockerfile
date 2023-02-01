# our base build image
FROM maven:3.6-jdk-8 as build

# copy the project files
COPY ./pom.xml ./pom.xml

# build all dependencies
# RUN mvn dependency:go-offline -B

# copy your other files
COPY ./src ./src

# build for release