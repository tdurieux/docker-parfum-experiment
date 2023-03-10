# Dockerfile for Prow CD postsubmit jobs
FROM quay.io/containers/buildah:v1.20.1

RUN dnf -y install \
		which \
		git \
		unzip \
		openssl \
		jq \
    && curl -f -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && export AWS_PAGER="" \
    && curl -f -L -s https://github.com/mikefarah/yq/releases/download/v4.2.0/yq_linux_amd64 --output /usr/bin/yq \
    && chmod +x /usr/bin/yq

RUN echo "Installing Helm ... " \
    && export HELM_TARBALL="helm.tar.gz" \
    && curl -fsSL https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz --output "${HELM_TARBALL}" \
    && tar xzf "${HELM_TARBALL}" --strip-components 1 -C /usr/bin \
    && rm "${HELM_TARBALL}"

