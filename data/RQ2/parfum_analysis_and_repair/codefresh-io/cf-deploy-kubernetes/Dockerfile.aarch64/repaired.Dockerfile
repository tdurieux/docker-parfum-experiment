FROM multiarch/alpine:aarch64-v3.6 AS builder

RUN apk update && apk add --no-cache curl

RUN curl -f -o kubectl1.9 -L https://storage.googleapis.com/kubernetes-release/release/v1.9.0/bin/linux/arm64/kubectl
RUN curl -f -o kubectl1.6 -L https://storage.googleapis.com/kubernetes-release/release/v1.6.0/bin/linux/arm64/kubectl


FROM multiarch/alpine:aarch64-v3.6

RUN apk add --no-cache --update bash

#copy both versions of kubectl to switch between them later.
COPY --from=builder kubectl1.9 /usr/local/bin/kubectl
COPY --from=builder kubectl1.6 /usr/local/bin/

RUN chmod +x /usr/local/bin/kubectl /usr/local/bin/kubectl1.6

WORKDIR /

ADD cf-deploy-kubernetes.sh /cf-deploy-kubernetes
ADD template.sh /template.sh

RUN \
    chmod +x /cf-deploy-kubernetes && \
    chmod +x /template.sh

CMD ["bash"]
