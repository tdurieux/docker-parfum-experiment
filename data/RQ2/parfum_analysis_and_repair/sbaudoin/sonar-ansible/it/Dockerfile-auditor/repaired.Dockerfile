ARG JDK_VERSION=8
FROM openjdk:${JDK_VERSION}
COPY it /usr/src/myapp/it
WORKDIR /usr/src/myapp/it