FROM openjdk:11-jre-slim

LABEL version="@version@"
LABEL description="@description@"
LABEL maintainer="Andrei Varabyeu <andrei_varabyeu@epam.com>"

ENV APP_FILE=@name@-@version@-exec.jar
ENV APP_DOWNLOAD_URL=https://dl.bintray.com/epam/reportportal/com/epam/reportportal/@name@/@version@/${APP_FILE}

RUN apt-get update && \
    apt-get install --no-install-recommends wget unzip openssl -y && \
    # Create start.sh script
    echo '#!/bin/sh \n exec java ${JAVA_OPTS} -jar ${APP_FILE}' > /start.sh && \
    chmod +x /start.sh && \
    # Download application
    wget -O /${APP_FILE} ${APP_DOWNLOAD_URL} && \
    # Remove APT cache
    rm -rf /var/lib/apt/lists/*

# Set default JAVA_OPTS
ENV JAVA_OPTS="-Xmx512m -Djava.security.egd=file:/dev/./urandom"

VOLUME ["/tmp"]

EXPOSE 8080
ENTRYPOINT ["/start.sh"]
