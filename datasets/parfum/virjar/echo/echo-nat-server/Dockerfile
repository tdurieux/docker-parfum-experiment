FROM openjdk:8-alpine
WORKDIR /app
COPY ./target/dist-echo-nat-1.1 .
COPY ./src/main/resources-env/docker/log4j.xml /app/conf/
EXPOSE 20000-21000
EXPOSE 5699
EXPOSE 5698
ENV API_ENTRY="http://echonew.virjar.com/"
ENV SERVER_ID="echo-nat-001"
ENV MAPPING_SPACE="20000-21000"
ENTRYPOINT "/app/bin/EchoNatServer.sh" \
    "--api-entry" "${API_ENTRY}" "--server-id" "${SERVER_ID}" \
    "--mapping-space" "${MAPPING_SPACE}"