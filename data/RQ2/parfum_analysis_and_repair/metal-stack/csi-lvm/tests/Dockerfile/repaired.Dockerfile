FROM alpine

ARG prtag
ENV PRTAG=$prtag

ARG prpullpolicy
ENV PRPULLPOLICY=$prpullpolicy

ARG prdevicepattern
ENV PRDEVICEPATTERN=$prdevicepattern

ENV KUBECONFIG /files/.kubeconfig

RUN apk add --no-cache --update ca-certificates \
 && apk add --no-cache --update -t deps curl bats \
 && curl -f -L https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && curl -f -L https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 -o /usr/local/bin/stern \
 && chmod +x /usr/local/bin/stern

COPY bats /bats
COPY files /files

