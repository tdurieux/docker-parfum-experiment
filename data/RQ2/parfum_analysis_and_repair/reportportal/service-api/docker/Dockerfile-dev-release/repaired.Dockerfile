FROM openjdk:11-jre-slim

### Set quay.io image cache. Since the build is for development only,
### there is no need to keep them forever
### details: https://support.coreos.com/hc/en-us/articles/115001384693-Tag-Expiration
LABEL quay.expires-after=1w

LABEL maintainer="Andrei Varabyeu <andrei_varabyeu@epam.com>"
LABEL version="@version@"
LABEL description="@description@"

ENV APP_FILE @name@-@version@
ENV APP_DOWNLOAD_URL https://dl.bintray.com/epam/reportportal/com/epam/reportportal/@name@/@version@/$APP_FILE.jar

RUN apt-get update && \
    apt-get install --no-install-recommends fonts-noto-core -y && rm -rf /var/lib/apt/lists/*;

RUN echo '#!/bin/sh \n exec java ${JAVA_OPTS} -jar ${APP_FILE}' > /start.sh && \
    chmod +x /start.sh

# Set default JAVA_OPTS and JAVA_APP
ENV JAVA_OPTS="-Xmx1g -Djava.security.egd=file:/dev/./urandom"
ENV JAVA_APP=/app/app.jar

VOLUME /tmp

RUN mkdir /app
COPY build/libs/service-api.jar $JAVA_APP

RUN sh -c "touch $JAVA_APP"

EXPOSE 8080
ENTRYPOINT /start.sh
