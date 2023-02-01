FROM openjdk:8-alpine
WORKDIR /app
COPY ./target/dist-echo-client-1.1 .
COPY ./src/main/resources-env/docker/logback.xml /app/conf/
ENV API_ENTRY="http://echonew.virjar.com/"
ENV CLIENT_ID="client-id-001"
ENV ECHO_ACCOUNT="10086"
ENV ECHO_PASSWORD="10086"
ENTRYPOINT "/app/bin/EchoClient.sh" \
    "--api-entry" "$API_ENTRY" "--client-id" "$CLIENT_ID" \
    "--echo-account" "$ECHO_ACCOUNT" \
    "--echo-password" "$ECHO_PASSWORD"