FROM anapsix/alpine-java:8_server-jre
RUN \
    apk update \
    && apk add --no-cache ca-certificates \
    && update-ca-certificates \
    && apk add --no-cache openssl \
    && wget -q -O - https://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz | tar xz
ENTRYPOINT ["/opt/jdk/bin/java", "-Djava.library.path=./DynamoDBLocal_lib", "-jar", "DynamoDBLocal.jar"]
CMD ["-help"]
