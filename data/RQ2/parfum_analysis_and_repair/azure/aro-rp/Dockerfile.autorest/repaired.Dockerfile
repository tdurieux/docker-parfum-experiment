ARG REGISTRY
FROM ${REGISTRY}/ubi8/nodejs-14

LABEL MAINTAINER="aos-azure"

ARG AUTOREST_VERSION

USER 0

# Autorest prerequisites
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf update -y && \
    dnf install -y libunwind-devel libicu && \
    dnf install -y python3-pip && \
    dnf clean all --enablerepo=\*

USER 1001

# Autorest
RUN npm install -g autorest@${AUTOREST_VERSION} && \
    autorest --reset --allow-no-input --csharp --ruby --python --java --go --nodejs --typescript --azure-validator --preview && \
    npm cache clean --force -f

ENTRYPOINT ["autorest"]
