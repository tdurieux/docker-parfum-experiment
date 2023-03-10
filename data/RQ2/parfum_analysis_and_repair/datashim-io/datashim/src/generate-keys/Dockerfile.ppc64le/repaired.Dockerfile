FROM ppc64le/alpine

ENV BUILD_DEPS="gettext"  \
    RUNTIME_DEPS="libintl"

RUN apk update && \
  apk add --update $RUNTIME_DEPS && \
  apk add --virtual build_deps $BUILD_DEPS &&  \
  cp /usr/bin/envsubst /usr/local/bin/envsubst && \
  apk del build_deps && \
  apk add --no-cache openssl curl bash && \
  rm -rf /var/cache/apk/* && \
  export ARCH=`arch` && \
  if [ "$ARCH" == "x86_64" ]; then export ARCH="amd64"; fi && \
  curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/$ARCH/kubectl && \
  chmod +x kubectl && mv kubectl /tmp/kubectl
ENV PATH="/tmp:${PATH}"
COPY "script.sh" /tmp
COPY "webhook.yaml.template" /tmp
WORKDIR /tmp
ENTRYPOINT [ "script.sh" ]
