###########################################
###            Build Stage              ###
###########################################
FROM maven:3.8.2-openjdk-8 AS maven-builder
COPY ./resources/server /usr/src/app
WORKDIR /usr/src/app
RUN mvn clean package


###########################################
###          Container Stage            ###
###########################################