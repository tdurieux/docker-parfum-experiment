# first build the jar
# assumes build context is the root of this project
FROM gradle:jdk14 as builder
COPY . .
RUN gradle pluginmanager:shadowJar

# run the built jar