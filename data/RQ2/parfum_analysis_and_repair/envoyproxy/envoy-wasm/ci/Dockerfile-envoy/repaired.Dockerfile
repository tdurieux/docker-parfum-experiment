ARG BUILD_OS=ubuntu
ARG BUILD_TAG=18.04

# Build stage
FROM buildpack-deps:$BUILD_TAG as build

RUN echo "d6c40440609a23483f12eb6295b5191e94baf08298a856bab6e15b10c3b82891  /tmp/su-exec.c" > /tmp/checksum \
    && curl -f -o /tmp/su-exec.c https://raw.githubusercontent.com/ncopa/su-exec/212b75144bbc06722fbd7661f651390dc47a43d1/su-exec.c \
    && sha256sum -c /tmp/checksum \
    && gcc -Wall /tmp/su-exec.c -o/usr/local/bin/su-exec \
    && chown root:root /usr/local/bin/su-exec \
    && chmod 0755 /usr/local/bin/su-exec

# Final stage
FROM $BUILD_OS:$BUILD_TAG
ARG TARGETPLATFORM

RUN apt-get update && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y ca-certificates \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/bin/su-exec /usr/local/bin/su-exec
RUN adduser --group --system envoy

RUN mkdir -p /etc/envoy

ARG ENVOY_BINARY_SUFFIX=_stripped
ADD ${TARGETPLATFORM}/build_release${ENVOY_BINARY_SUFFIX}/* /usr/local/bin/
ADD configs/google_com_proxy.v2.yaml /etc/envoy/envoy.yaml

EXPOSE 10000

COPY ci/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["envoy", "-c", "/etc/envoy/envoy.yaml"]
