FROM @REPOSITORY@/eunomia-base:@IMAGE_TAG@

ENV HELM_VERSION="v3.2.4"

USER root

RUN curl -f -L https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar --strip-components 1 --directory /usr/bin -zxv linux-amd64/helm

COPY bin/processTemplates.sh /usr/local/bin/processTemplates.sh

USER ${USER_UID}
