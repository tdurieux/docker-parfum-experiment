FROM alpine
RUN apk add --no-cache curl jq \
 && curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
 && chmod +x /usr/local/bin/kubectl
ADD kube-lustre-configurator.sh drbd.yaml lustre.yaml lustre-client.yaml /
CMD ["/kube-lustre-configurator.sh"]
