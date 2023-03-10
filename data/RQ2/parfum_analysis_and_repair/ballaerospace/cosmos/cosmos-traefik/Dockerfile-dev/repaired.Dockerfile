ARG COSMOS_REGISTRY=docker.io
FROM ${COSMOS_REGISTRY}/traefik:2.7.0
COPY cacert.pem /devel/cacert.pem
ENV SSL_CERT_FILE=/devel/cacert.pem
ENV CURL_CA_BUNDLE=/devel/cacert.pem
ENV REQUESTS_CA_BUNDLE=/devel/cacert.pem
ENV NODE_EXTRA_CA_CERTS=/devel/cacert.pem
COPY ./traefik-dev.yaml /etc/traefik/traefik.yaml
EXPOSE 80