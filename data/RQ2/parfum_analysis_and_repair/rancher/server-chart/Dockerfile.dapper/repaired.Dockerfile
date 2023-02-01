FROM debian

ARG DAPPER_HOST_ARCH
ENV HOST_ARCH=${DAPPER_HOST_ARCH} ARCH=${DAPPER_HOST_ARCH}

RUN apt-get update && \
    apt-get install --no-install-recommends -y git curl ca-certificates && \
    rm -f /bin/sh && ln -s /bin/bash /bin/sh && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash && \
    helm init -c && \
    helm plugin install https://github.com/lrills/helm-unittest

ENV HELM_HOME /root/.helm
ENV DAPPER_ENV REPO TAG DRONE_TAG
ENV DAPPER_SOURCE /src/
ENV DAPPER_OUTPUT ./charts
ENV DAPPER_DOCKER_SOCKET true
ENV TRASH_CACHE ${DAPPER_SOURCE}/.trash-cache
ENV HOME ${DAPPER_SOURCE}
WORKDIR ${DAPPER_SOURCE}

ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]
