FROM alpine:3.12.3
RUN apk upgrade --no-cache
RUN apk update && apk add --no-cache curl git
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/v1.21.3/bin/linux/amd64/kubectl
RUN chmod u+x kubectl && mv kubectl /usr/local/bin/kubectl
COPY dist-static/aci-containers-operator /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/aci-containers-operator"]
