FROM alpine:3.6 AS builder

RUN apk update && apk add curl

RUN export ARCH=$([[ "$(uname -m)" == "aarch64" ]] && echo "arm64" || echo "amd64") && \
    curl -o kubectl1.22 -L https://storage.googleapis.com/kubernetes-release/release/v1.22.0/bin/linux/${ARCH}/kubectl && \
    curl -o kubectl1.21 -L https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/${ARCH}/kubectl && \
    curl -o kubectl1.20 -L https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/${ARCH}/kubectl && \
    curl -o kubectl1.19 -L https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/${ARCH}/kubectl && \
    curl -o kubectl1.18 -L https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/${ARCH}/kubectl && \
    curl -o kubectl1.17 -L https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/linux/${ARCH}/kubectl && \
    curl -o kubectl1.16 -L https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/${ARCH}/kubectl && \
    curl -o kubectl1.15 -L https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/${ARCH}/kubectl && \
    curl -o kubectl1.14 -L https://storage.googleapis.com/kubernetes-release/release/v1.14.0/bin/linux/${ARCH}/kubectl && \
    curl -o kubectl1.13 -L https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/${ARCH}/kubectl && \
    curl -o kubectl1.12 -L https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/${ARCH}/kubectl && \
    curl -o kubectl1.11 -L https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/${ARCH}/kubectl && \
    curl -o kubectl1.10 -L https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/${ARCH}/kubectl && \
    curl -o kubectl1.6 -L https://storage.googleapis.com/kubernetes-release/release/v1.6.0/bin/linux/${ARCH}/kubectl


FROM alpine:3.15

RUN apk --no-cache update && apk upgrade && apk add --update bash

#copy all versions of kubectl to switch between them later.
COPY --from=builder kubectl1.22 /usr/local/bin/
COPY --from=builder kubectl1.21 /usr/local/bin/
COPY --from=builder kubectl1.20 /usr/local/bin/
COPY --from=builder kubectl1.19 /usr/local/bin/
COPY --from=builder kubectl1.18 /usr/local/bin/
COPY --from=builder kubectl1.17 /usr/local/bin/
COPY --from=builder kubectl1.16 /usr/local/bin/
COPY --from=builder kubectl1.15 /usr/local/bin/
COPY --from=builder kubectl1.14 /usr/local/bin/
COPY --from=builder kubectl1.13 /usr/local/bin/
COPY --from=builder kubectl1.12 /usr/local/bin/
COPY --from=builder kubectl1.11 /usr/local/bin/
COPY --from=builder kubectl1.10 /usr/local/bin/kubectl
COPY --from=builder kubectl1.6 /usr/local/bin/

RUN chmod +x /usr/local/bin/kubectl \
    /usr/local/bin/kubectl1.6 \
    /usr/local/bin/kubectl1.11 \
    /usr/local/bin/kubectl1.12 \
    /usr/local/bin/kubectl1.13 \
    /usr/local/bin/kubectl1.14 \
    /usr/local/bin/kubectl1.15 \
    /usr/local/bin/kubectl1.16 \
    /usr/local/bin/kubectl1.17 \
    /usr/local/bin/kubectl1.18 \
    /usr/local/bin/kubectl1.19 \
    /usr/local/bin/kubectl1.20 \
    /usr/local/bin/kubectl1.21 \
    /usr/local/bin/kubectl1.22

WORKDIR /

ADD cf-deploy-kubernetes.sh /cf-deploy-kubernetes
ADD template.sh /template.sh

RUN adduser -D -h /home/cfu -s /bin/bash cfu \
    && chgrp -R $(id -g cfu) /cf-deploy-kubernetes /usr/local/bin /template.sh \
    && chmod -R g+rwX /cf-deploy-kubernetes /usr/local/bin /template.sh
USER cfu

CMD ["bash"]
