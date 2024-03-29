FROM google/cloud-sdk:alpine

RUN apk add --no-cache --update \
    curl \
    which \
    jq \
    bash \
    openssl

RUN gcloud components install kubectl

ADD * /kfp/cache/deployer/
RUN chmod -R 777 /kfp/cache/deployer

WORKDIR /kfp/cache/deployer

RUN chmod +x deploy-cache-service.sh
RUN chmod +x webhook-create-signed-cert.sh
RUN chmod +x webhook-patch-ca-bundle.sh

#COPY third_party/license.txt /bin/license.txt

ENTRYPOINT ["/bin/sh", "/kfp/cache/deployer/deploy-cache-service.sh"]
