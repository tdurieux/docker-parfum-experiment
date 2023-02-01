FROM java:openjdk-8u111-alpine
RUN apk --no-cache add curl
CMD ./wait-for -t 300 $CONSUL_HOST:$CONSUL_PORT -- \
    echo "All dependencies ready. Starting application..." && \
    java ${JAVA_OPTS} -jar mail-all.jar
COPY build/libs/*-all.jar mail-all.jar
COPY wait-for wait-for