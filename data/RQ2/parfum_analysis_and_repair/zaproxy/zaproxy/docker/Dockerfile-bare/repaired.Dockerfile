# This dockerfile builds the zap stable release
FROM openjdk:8-jdk-alpine AS builder

WORKDIR /zap

RUN apk add --no-cache wget xmlstarlet bash

# Download and expand the latest stable release
RUN wget -qO- https://raw.githubusercontent.com/zaproxy/zap-admin/master/ZapVersions.xml | xmlstarlet sel -t -v //url |grep -i Linux | wget --content-disposition -i - -O - | tar zxv && \
	mv ZAP*/* . && \
	rm -R ZAP*

# Update add-ons
RUN ./zap.sh -cmd -silent -addonupdate
# Copy them to installation directory
RUN cp /root/.ZAP/plugin/*.zap plugin/ || :

FROM openjdk:8-jdk-alpine
LABEL maintainer="psiinon@gmail.com"

WORKDIR /zap
COPY --from=builder /zap .
COPY policies /home/zap/.ZAP/policies/

RUN echo "zap2docker-bare" > /zap/container

RUN echo "http://dl-3.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories &&\
    apk add --update --no-cache bash netcat-openbsd && \
    adduser -h /home/zap -s /bin/bash zap -D zap && \
    rm -rf /var/cache/apk/* && \
    chown zap /zap && \
    chgrp zap /zap && \
    chown -R zap:zap /zap && \
    chown -R zap:zap /home/zap/.ZAP/

#Change to the zap user so things get done as the right person (apart from copy)