FROM openjdk:11-jre-slim

### Set quay.io image cache. Since the build is for development only,
### there is no need to keep them forever
### details: https://support.coreos.com/hc/en-us/articles/115001384693-Tag-Expiration
LABEL quay.expires-after=1w

LABEL maintainer="Andrei Varabyeu <andrei_varabyeu@epam.com>"
LABEL version="@version@"
LABEL description="@description@"

RUN apt-get update && \
    apt-get install --no-install-recommends openssl -y && rm -rf /var/lib/apt/lists/*;

RUN echo '#!/bin/sh \n exec java ${JAVA_OPTS} -jar ${APP_FILE}' > /start.sh && \
    chmod +x /start.sh

# Set default JAVA_OPTS and APP_FILE
ENV JAVA_OPTS="-Xmx1g -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp -Djava.security.egd=file:/dev/./urandom"
ENV APP_FILE=/app/app.jar

VOLUME ["/tmp"]

RUN mkdir /app
COPY build/libs/app.jar $APP_FILE

RUN sh -c "touch $APP_FILE"

EXPOSE 8080
ENTRYPOINT ["/start.sh"]
