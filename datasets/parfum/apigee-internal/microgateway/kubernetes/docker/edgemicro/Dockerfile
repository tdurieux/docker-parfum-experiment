FROM node:14.19-buster-slim

COPY installnode.sh /tmp
COPY --chown=101:101 installedgemicro.sh /tmp

# create user and group for microgateway
#RUN apk add --no-cache sed grep && \
RUN addgroup --system --gid 101 apigee && \
    adduser --shell /bin/bash --uid 101 --system --ingroup apigee --home /opt/apigee apigee

ENV NODE_ENV production

#install node.js
RUN chmod +x /tmp/installnode.sh && \
    /bin/bash /tmp/installnode.sh && \
    rm -f /tmp/installnode.sh && \
    userdel --remove node

USER apigee
WORKDIR /opt/apigee
RUN mkdir /opt/apigee/.edgemicro && mkdir /opt/apigee/logs && mkdir /opt/apigee/plugins
VOLUME /opt/apigee/.edgemicro
VOLUME /opt/apigee/logs
VOLUME /opt/apigee/plugins

# copy tls files if needed
# COPY key.pem /opt/apigee/.edgemicro
# COPY cert.pem /opt/apigee/.edgemicro

# copy entrypoint
COPY --chown=101:101 entrypoint.sh /opt/apigee

# initialize edgemicro
RUN /bin/bash /tmp/installedgemicro.sh&& \
    rm -f /tmp/installedgemicro.sh

# Expose ports
EXPOSE 8000
EXPOSE 8443

ENTRYPOINT ["/opt/apigee/entrypoint.sh"]
