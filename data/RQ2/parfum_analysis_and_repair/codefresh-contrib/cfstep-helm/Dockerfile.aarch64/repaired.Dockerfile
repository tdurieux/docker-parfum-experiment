ARG HELM_VERSION

FROM arm64v8/golang:1.12-buster as setup
ARG HELM_VERSION
RUN echo "HELM_VERSION is set to: ${HELM_VERSION}" && mkdir /temp
RUN curl -f -L "https://get.helm.sh/helm-v${HELM_VERSION}-linux-arm64.tar.gz" -o helm.tar.gz \
    && tar -zxvf helm.tar.gz \
    && mv ./linux-arm64/helm /usr/local/bin/helm \
    && bash -c 'if [[ "${HELM_VERSION}" == 2* ]]; then helm init --client-only; echo "using helm3, no need to initialize helm"; fi' \
    && helm plugin install https://github.com/hypnoglow/helm-s3.git \
    && helm plugin install https://github.com/nouney/helm-gcs.git \
    && helm plugin install https://github.com/chartmuseum/helm-push.git && rm helm.tar.gz

# Run acceptance tests
COPY Makefile Makefile
COPY bin/ bin/
COPY lib/ lib/
COPY acceptance_tests/ acceptance_tests/
RUN apt-get update \
    && apt-get install --no-install-recommends -y python3-venv \
    && make acceptance && rm -rf /var/lib/apt/lists/*;


FROM arm64v8/alpine:3.6

ARG KUBE_VERSION="v1.14.3"

ARG HELM_VERSION

RUN echo "HELM_VERSION is set to: ${HELM_VERSION}"

ENV FILENAME="helm-v${HELM_VERSION}-linux-arm64.tar.gz"

RUN apk add --update ca-certificates && update-ca-certificates \
    && apk add --update curl \
    && apk add bash \
    && apk add jq \
    && apk add python \
    && apk add make \
    && apk add git \
    && apk add openssl \
    && apk add py-pip \
    && pip install --no-cache-dir yq \
    && curl -f -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/arm64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && curl -f -L https://get.helm.sh/${FILENAME} -o /tmp/${FILENAME} \
    && tar -zxvf /tmp/${FILENAME} -C /tmp \
    && mv /tmp/linux-arm64/helm /bin/helm \
    # Cleanup uncessary files
    && rm /var/cache/apk/* \
    && rm -rf /tmp/*

RUN if [[ "${HELM_VERSION}" == 2* ]]; then helm init --client-only; echo "using helm3, no need to initialize helm"; fi

ARG HELM_VERSION
COPY --from=setup /temp /root/.helm/* /root/.helm/
COPY bin/* /opt/bin/
RUN chmod +x /opt/bin/*
COPY lib/* /opt/lib/

# Install Python3
RUN apk add --no-cache python3 \
    && rm -rf /root/.cache

ENV HELM_VERSION ${HELM_VERSION}

ENTRYPOINT ["/opt/bin/release_chart"]
