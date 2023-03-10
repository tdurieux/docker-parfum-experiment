# Dockerfile for hyperledger cello fabirc operator agent
#
# @see https://github.com/hyperledger/cello/tree/master/docs/agents/fabric-operator.md
#
FROM alpine/git AS BUILD

RUN cd /tmp && git init cello && cd cello                           && \
    git remote add origin https://github.com/hyperledger/cello.git  && \
    git config core.sparsecheckout true                             && \
    echo "src/agent/fabric-operator/*" >> .git/info/sparse-checkout && \
    git pull --depth=1 origin master
RUN release=$(wget -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt) && \
    wget https://storage.googleapis.com/kubernetes-release/release/${release}/bin/linux/amd64/kubectl -O /kubectl

FROM alpine
RUN apk update && apk add --no-cache jq gettext curl bash && mkdir /home/app
COPY --from=build /tmp/cello/src/agent/fabric-operator/deploy /home/app
COPY --from=build /tmp/cello/src/agent/fabric-operator/agent /home/app
COPY --from=build /kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl


ENV HOME /home
WORKDIR /home/app
ENV KUBECONFIG /home/.kube/config

CMD bash /home/app/deploy_cr.sh
