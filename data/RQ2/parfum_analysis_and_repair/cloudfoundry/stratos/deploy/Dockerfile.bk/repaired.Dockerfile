FROM splatform/stratos-bk-build-base:leap15_2 as builder
ARG stratos_version
RUN mkdir -p /home/stratos
WORKDIR /home/stratos
COPY --chown=stratos:users . /home/stratos
RUN go version
RUN npm install && npm cache clean --force;
RUN npm run build-backend

FROM splatform/stratos-bk-base:leap15_2 as common-build
COPY --from=builder /home/stratos/src/jetstream/jetstream /srv/
COPY --from=builder /home/stratos/src/jetstream/plugins.yaml /srv/
RUN chmod +x /srv/jetstream

# use --target=prod-build to build a backend image for Kubernetes
FROM splatform/stratos-bk-base:leap15_2 as prod-build
COPY deploy/containers/proxy/entrypoint.sh /entrypoint.sh
COPY /deploy/tools/generate_cert.sh /generate_cert.sh
COPY --from=common-build /srv /srv
RUN mkdir /srv/templates
COPY src/jetstream/templates /srv/templates
EXPOSE 443
ENTRYPOINT ["/entrypoint.sh"]

# use --target=dev-build to build backend image for development
FROM prod-build as dev-build
RUN CERTS_PATH=dev-certs /generate_cert.sh
