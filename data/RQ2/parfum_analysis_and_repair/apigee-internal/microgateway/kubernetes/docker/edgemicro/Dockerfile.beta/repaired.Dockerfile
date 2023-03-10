FROM node:8-alpine

COPY install-beta.sh /tmp

# create user and group for microgateway
RUN apk add --no-cache sed grep && \
    addgroup -S apigee -g 101 && \
    adduser -s /bin/bash -u 100 -S -G apigee apigee -h /opt/apigee

WORKDIR /opt/apigee

# copy entrypoint
COPY entrypoint.sh /opt/apigee

ENV NODE_ENV production

#install and initialize microgateway
RUN chmod +x /tmp/install-beta.sh && \
    /bin/bash /tmp/install-beta.sh && \
    rm -f /tmp/install-beta.sh && \
    deluser --remove-home node

VOLUME /opt/apigee/.edgemicro
VOLUME /opt/apigee/logs
VOLUME /opt/apigee/plugins

# copy tls files if needed
# COPY key.pem /opt/apigee/.edgemicro
# COPY cert.pem /opt/apigee/.edgemicro

# Expose ports
EXPOSE 8000
EXPOSE 8443
USER apigee
ENTRYPOINT ["entrypoint"]