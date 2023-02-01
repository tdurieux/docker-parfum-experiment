# syntax=docker/dockerfile:experimental

FROM maven:3.8.1-adoptopenjdk-8 as build
VOLUME ["/tmp"]

WORKDIR /mnt/mojito

# copy source and make sure node* are not present (Mac version may conflict with Linux)
COPY . /mnt/mojito

ENV PATH="/mnt/mojito/webapp/node/:${PATH}"
RUN --mount=type=cache,target=/root/.m2 --mount=type=cache,target=/mnt/mojito/node --mount=type=cache,target=/mnt/mojito/node_module mvn clean install -DskipTests -P'!frontend'

FROM adoptopenjdk/openjdk8:alpine-jre
VOLUME /tmp

ENV MOJITO_BIN=/usr/local/mojito/bin
ENV PATH $PATH:${MOJITO_BIN}
ENV MOJITO_HOST=localhost
ENV MOJITO_SCHEME=http
ENV MOJITO_PORT=8080


COPY --from=build /mnt/mojito/cli/target/mojito-cli-*-exec.jar ${MOJITO_BIN}/mojito-cli.jar
RUN sh -c 'touch ${MOJITO_BIN}/mojito-cli.jar'

# Create the shell wrapper for the jar
RUN /bin/echo -e "#!/bin/sh \n\
java -Dl10n.resttemplate.host=\${MOJITO_HOST} \\\\\n \
     -Dl10n.resttemplate.scheme=\${MOJITO_SCHEME} \\\\\n \
     -Dl10n.resttemplate.port=\${MOJITO_PORT} \\\\\n \
     -jar $MOJITO_BIN/mojito-cli.jar \"\${@}\"" \
    >> /usr/local/mojito/bin/mojito && chmod +x $MOJITO_BIN/mojito

ENTRYPOINT ["mojito"]