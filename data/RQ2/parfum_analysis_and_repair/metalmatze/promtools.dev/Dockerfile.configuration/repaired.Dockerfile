FROM alpine

RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.16.2/bin/linux/amd64/kubectl
RUN chmod +x kubectl && mv kubectl /usr/bin/

COPY kubernetes.yaml /data/kubernetes.yaml

ENTRYPOINT ["/usr/bin/kubectl"]