FROM registry.nordix.org/cloud-native/kpng:latest
RUN apk add --no-cache jq
COPY --chown=0:0 _output scripts /bin/
ENTRYPOINT ["/bin/kpng-example-start"]
