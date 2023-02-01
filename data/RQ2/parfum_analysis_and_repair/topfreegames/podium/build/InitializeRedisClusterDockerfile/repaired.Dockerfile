FROM redis:6.2.1-alpine

ARG HOST_IP

ENV IP $HOST_IP

COPY ./build/package/initialize_cluster.sh /initialize_cluster.sh

RUN apk --no-cache --update add bind-tools  bash && \
  chmod +x /initialize_cluster.sh

ENTRYPOINT ["/bin/sh", "-c", "/initialize_cluster.sh"]