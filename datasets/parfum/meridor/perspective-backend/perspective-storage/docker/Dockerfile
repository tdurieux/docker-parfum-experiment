FROM openjdk:8-jre-alpine

MAINTAINER Ivan Krutov <vania-pooh@meridor.org>

ENV LANG=en_US.UTF-8 \
    GC_OPTS="-XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled" \
    MEMORY_OPTS="-Xmx1024m" \
    NETWORK_OPTS="" \
    LOGGING_OPTS="" \
    MISC_OPTS=""

EXPOSE 5801

COPY lib /usr/share/perspective/perspective-storage/lib
COPY ${project.build.finalName}.jar usr/share/perspective/perspective-storage

COPY entrypoint.sh /

ENTRYPOINT /entrypoint.sh