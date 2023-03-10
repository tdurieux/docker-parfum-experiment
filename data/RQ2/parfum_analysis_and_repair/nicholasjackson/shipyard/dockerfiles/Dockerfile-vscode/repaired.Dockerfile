FROM codercom/code-server:latest AS codercom

FROM nicholasjackson/consul-k8s-tools:latest

ENV GOPATH="/home/coder/go"
ENV PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"
ENV GO111MODULE="on"
ENV SHELL=/bin/bash

ENV GO_VERSION=1.13.4
ENV EXT_GO_VERSION=0.11.9
ENV EXT_SQUASH_VERSION=0.5.18
ENV EXT_HCL_VERSION=0.0.5
ENV EXT_YAML_VERSION=0.5.3
ENV EXT_NORD_VERSION=0.12.0

# Make the default user admin
USER root

# Install Go and packages for VSCode
RUN curl -f -sL https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz -o /tmp/go${GO_VERSION}.tar.gz && \
    tar -C /usr/local -xzf /tmp/go${GO_VERSION}.tar.gz && \
    rm /tmp/go${GO_VERSION}.tar.gz && \
    go get github.com/mdempsky/gocode && \
    go get golang.org/x/tools/gopls && \
    go get github.com/uudashr/gopkgs/cmd/gopkgs && \
    go get github.com/ramya-rao-a/go-outline && \
    go get github.com/acroca/go-symbols && \
    go get golang.org/x/tools/cmd/guru && \
    go get golang.org/x/tools/cmd/gorename && \
    go get github.com/go-delve/delve/cmd/dlv && \
    go get github.com/stamblerre/gocode && \
    go get github.com/rogpeppe/godef && \
    go get github.com/sqs/goreturns && \
    go get golang.org/x/lint/golint && \
    go get github.com/davidrjenni/reftools/cmd/fillstruct && \
    go get github.com/haya14busa/goplay/cmd/goplay && \
    go get github.com/godoctor/godoctor && \
    go get golang.org/x/tools/cmd/goimports && \
    go get github.com/josharian/impl && \
    go get github.com/cweill/gotests && \
    go get github.com/fatih/gomodifytags


# Install Node
RUN curl -f -sL https://deb.nodesource.com/setup_13.x -o /tmp/nodesetup.sh && \
      bash /tmp/nodesetup.sh && \
      apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;


# Add Code server
COPY --from=codercom /usr/local/bin/code-server /usr/local/bin/code-server

# Extensions to code-server
RUN mkdir -p /root/.local/share/code-server/extensions

# VSCode Go
RUN curl -f -JL https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-vscode/vsextensions/Go/${EXT_GO_VERSION}/vspackage | \
      bsdtar -xvf - extension && \
      mv ./extension /root/.local/share/code-server/extensions/ms-vscode.go-${EXT_GO_VERSION} && \
      cd /root/.local/share/code-server/extensions/ms-vscode.go-${EXT_GO_VERSION} && \
      npm i && npm cache clean --force;


# Squash debugger from main VSCode marketplace not code-server
RUN curl -f -JL https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ilevine/vsextensions/squash/${EXT_SQUASH_VERSION}/vspackage | \
      bsdtar -xvf - extension && \
      mv ./extension /root/.local/share/code-server/extensions/ilevine.squash-${EXT_SQUASH_VERSION} && \
      cd /root/.local/share/code-server/extensions/ilevine.squash-${EXT_SQUASH_VERSION} && \
      npm i && npm cache clean --force;

# HCL
RUN curl -f -JL https://marketplace.visualstudio.com/_apis/public/gallery/publishers/wholroyd/vsextensions/HCL/${EXT_HCL_VERSION}/vspackage | \
      bsdtar -xvf - extension && \
      mv ./extension /root/.local/share/code-server/extensions/wholroyd.HCL-${EXT_HCL_VERSION} && \
      cd /root/.local/share/code-server/extensions/wholroyd.HCL-${EXT_HCL_VERSION} && \
      npm i && npm cache clean --force;

# YAML Formatting
RUN curl -f -JL https://marketplace.visualstudio.com/_apis/public/gallery/publishers/redhat/vsextensions/vscode-yaml/${EXT_YAML_VERSION}/vspackage | \
      bsdtar -xvf - extension && \
      mv ./extension /root/.local/share/code-server/extensions/redhat.vscode-yaml-${EXT_YAML_VERSION} && \
      cd /root/.local/share/code-server/extensions/redhat.vscode-yaml-${EXT_YAML_VERSION} && \
      npm i && npm cache clean --force;

# NORD Color scheme
RUN curl -f -JL https://marketplace.visualstudio.com/_apis/public/gallery/publishers/arcticicestudio/vsextensions/nord-visual-studio-code/${EXT_NORD_VERSION}/vspackage | \
      bsdtar -xvf - extension && \
      mv ./extension /root/.local/share/code-server/extensions/arcticicestudio.nord-visual-studio-code-${EXT_NORD_VERSION} && \
      cd /root/.local/share/code-server/extensions/arcticicestudio.nord-visual-studio-code-${EXT_NORD_VERSION} && \
      npm i && npm cache clean --force;

EXPOSE 8080
CMD ["code-server", "--allow-http", "--auth=none"]
