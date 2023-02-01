ARG TAG
ARG CP_BASE_IMAGE
FROM ${CP_BASE_IMAGE}:${TAG}
COPY ./target/*.jar ./
ENV JAVA_OPTS ""
CMD [ "bash", "-c", "cub sr-ready schema-registry 8081 120 && java ${JAVA_OPTS} -jar *-jar-with-dependencies.jar" ]