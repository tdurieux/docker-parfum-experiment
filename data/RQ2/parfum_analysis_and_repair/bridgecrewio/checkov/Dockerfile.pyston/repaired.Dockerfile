FROM pyston/slim:2.3.4

RUN set -eux; \
    apt-get update; \
    apt-get -y --no-install-recommends upgrade; \
    apt-get install -y --no-install-recommends \
            ca-certificates \
            git \
            wget \
            curl \
    ; \
    \
    wget -q -O get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3; \
    chmod 700 get_helm.sh; \
    VERIFY_CHECKSUM=true ./get_helm.sh; \
    rm ./get_helm.sh; \
    \
    wget -q -O get_kustomize.sh https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh; \
    chmod 700 get_kustomize.sh; \
    ./get_kustomize.sh; mv /kustomize /usr/bin/kustomize; \
    rm ./get_kustomize.sh; \
    \
    apt-get remove -y wget curl; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends build-essential gcc; \
    \
    pip install --no-cache-dir -U checkov; \
    \
    apt-get remove -y build-essential gcc; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*

COPY ./github_action_resources/entrypoint.sh /entrypoint.sh
COPY ./github_action_resources/checkov-problem-matcher.json /usr/local/lib/checkov-problem-matcher.json
COPY ./github_action_resources/checkov-problem-matcher-softfail.json /usr/local/lib/checkov-problem-matcher-softfail.json

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]