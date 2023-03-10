FROM openjdk:8

RUN mkdir /app
WORKDIR /app

COPY iam-test-client.jar /app/
CMD java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap $IAM_CLIENT_JAVA_OPTS -jar iam-test-client.jar

# Embed TINI since compose v3 syntax do not support the init
# option to run docker --init
#
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]