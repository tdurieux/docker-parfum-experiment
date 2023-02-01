# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.222.0/containers/go/.devcontainer/base.Dockerfile

# [Choice] Go version (use -bullseye variants on local arm64/Apple Silicon): 1, 1.16, 1.17, 1-bullseye, 1.16-bullseye, 1.17-bullseye, 1-buster, 1.16-buster, 1.17-buster
ARG VARIANT="1.17-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/go:0-${VARIANT}

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

RUN curl -L -o /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-linux-amd64 && chmod 0755 /usr/local/bin/kind
RUN curl -L -o /usr/local/bin/clusterctl https://github.com/kubernetes-sigs/cluster-api/releases/download/v0.4.7/clusterctl-linux-amd64 && chmod 0755 /usr/local/bin/clusterctl

RUN curl -L https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz -o - | \
    tar -C /usr/local/bin -xz k9s && \
    chmod 0755 /usr/local/bin/k9s

# RUN curl -sS https://webinstall.dev/k9s | bash

# RUN docker pull docker pull kindest/node:v1.23.4

# RUN pwd
# COPY initialize.sh /home/vscode/initialize.sh
# COPY kind-cluster-with-extramounts.yaml /home/vscode/

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment the next lines to use go get to install anything else you need
#RUN chown -R vscode /home/vscode/.minikube
#USER vscode
# RUN go get -x <your-dependency-or-tool>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
