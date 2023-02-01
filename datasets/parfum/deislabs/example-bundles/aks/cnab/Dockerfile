FROM alpine:latest

ENV HELM_LATEST_VERSION="v2.10.0"

# install helm
RUN apk add --update ca-certificates \
 && apk add --update -t deps wget \
 && wget https://storage.googleapis.com/kubernetes-helm/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && tar -xvf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && mv linux-amd64/helm /usr/local/bin \
 && apk del --purge deps \
 && rm /var/cache/apk/* \
 && rm -f /helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && apk update && \
  apk add bash py3-pip && \
  apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make && \
  pip3 install --upgrade pip && \
  pip3 install --upgrade requests && \
  pip3 install azure-cli && \
  ln -s /usr/bin/python3 /usr/bin/python

COPY app/run /cnab/app/run
COPY app/rbac-config.yaml /cnab/app/rbac-config.yaml
COPY Dockerfile cnab/Dockerfile

CMD [ "/cnab/app/run" ]
