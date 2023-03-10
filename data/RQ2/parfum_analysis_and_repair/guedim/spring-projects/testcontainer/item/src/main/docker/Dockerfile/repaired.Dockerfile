FROM openjdk:8-jdk-alpine

RUN apk update && apk upgrade && apk add --no-cache netcat-openbsd
RUN mkdir -p /usr/local/item

COPY @project.build.finalName@.jar /usr/local/item/
COPY run.sh run.sh

RUN chmod +x run.sh
CMD ./run.sh
