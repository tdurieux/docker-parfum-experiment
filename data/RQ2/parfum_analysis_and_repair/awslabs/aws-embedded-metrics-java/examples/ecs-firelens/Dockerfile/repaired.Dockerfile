#Make sure the jdk pulled in dockerfile matches your IDE compile version used for compiling Jar file
FROM openjdk:11
RUN mkdir -p /app

# copy the source files over