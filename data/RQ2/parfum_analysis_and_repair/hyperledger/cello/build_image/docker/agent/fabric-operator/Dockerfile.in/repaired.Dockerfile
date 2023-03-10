# Dockerfile for hyperledger cello fabirc operator agent
#
# @see https://github.com/hyperledger/cello/tree/master/docs/agents/fabric-operator.md
#
FROM alpine
RUN release=$(wget -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt) && \
    wget https://storage.googleapis.com/kubernetes-release/release/${release}/bin/linux/amd64/kubectl \
    -O /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl
RUN apk update && apk add --no-cache jq gettext curl bash && mkdir /home/app
ADD src/agent/fabric-operator/deploy /home/app
ADD src/agent/fabric-operator/agent /home/app

ENV HOME /home
WORKDIR /home/app
ENV KUBECONFIG /home/.kube/config

CMD bash /home/app/deploy_cr.sh
