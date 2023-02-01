FROM --platform=${BUILDPLATFORM} docker:20.10.14-alpine3.15

WORKDIR /
COPY docker-extension/vm/commands/gosh-image-sha.sh /
RUN chmod +x /gosh-image-sha.sh
ENTRYPOINT [ "/gosh-image-sha.sh" ]