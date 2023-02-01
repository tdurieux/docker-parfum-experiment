FROM us.gcr.io/platform-205701/alpine:safe-alpine3.15.4-bt1276

# Add the capsule JAR and config.yml
COPY ng-dashboard-service.jar config.yml  /opt/harness/

RUN wget https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_amd64 -O /usr/bin/yq -O /usr/bin/yq
RUN chmod +x /usr/bin/yq

COPY scripts /opt/harness

RUN chmod +x /opt/harness/*.sh
RUN mkdir -p /opt/harness/plugins

RUN addgroup -S 65534 && adduser -S 65534 -G 65534
RUN chown -R 65534:65534 /opt/harness/ /tmp

RUN chmod 700 -R /opt/harness/
RUN chmod 700 -R /tmp
USER 65534

WORKDIR /opt/harness

CMD [ "./run.sh" ]