FROM plugins/base:linux-arm

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>" \
  org.label-schema.name="Drone Packer" \
  org.label-schema.vendor="Bo-Yi Wu" \
  org.label-schema.schema-version="1.0"

ENV PACKER_VERSION 1.7.4
ENV PACKER_ARCH arm
RUN wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_${PACKER_ARCH}.zip -O packer.zip && \
  unzip packer.zip -d /bin && \
  rm -f packer.zip

COPY release/linux/arm/drone-packer /bin/

ENTRYPOINT ["/bin/drone-packer"]