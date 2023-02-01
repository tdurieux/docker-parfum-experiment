FROM ubuntu:20.04

# Install prerequisite
RUN apt update && \
    apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository ppa:git-core/ppa && \
    apt update && \
    apt install --no-install-recommends -y wget curl build-essential git git-lfs unzip && rm -rf /var/lib/apt/lists/*;

# Use Bash instead of Dash
RUN ln -sf bash /bin/sh

# Install python3
RUN apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

# Install azure-cli (using pip)
RUN python3 -m pip install azure.cli

# Install docker
RUN apt-get install --no-install-recommends -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release && \
    curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null && \
    add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install --no-install-recommends -y docker-ce-cli && rm -rf /var/lib/apt/lists/*;

# Install golang
RUN GO_VERSION=1.17.9 && \
    curl -f -LO https://golang.org/dl/go${GO_VERSION}.linux-$(dpkg --print-architecture).tar.gz && \
    ARCH=$(dpkg --print-architecture) && if [ ${ARCH} == "amd64" ]; then go_sha256="9dacf782028fdfc79120576c872dee488b81257b1c48e9032d122cfdb379cca6" ; elif [ ${ARCH} == "arm64" ]; then go_sha256="44dcdcd4f0fa6f83c15ef70b31580f1e3f95895c2f11a00e36c440c3554b6ad5" ; fi && \
    echo "$go_sha256  go${GO_VERSION}.linux-$(dpkg --print-architecture).tar.gz" | sha256sum -c - && \
    tar -C /usr/local -xvzf go${GO_VERSION}.linux-$(dpkg --print-architecture).tar.gz && \
    rm -rf go${GO_VERSION}.linux-$(dpkg --print-architecture).tar.gz

# Install kubectl
RUN curl -f -LO "https://dl.k8s.io/release/$( curl -f -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl" && \
    curl -f -LO "https://dl.k8s.io/$( curl -f -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && \
    chmod +x ./kubectl && mv ./kubectl /usr/bin/kubectl && \
    rm kubectl.sha256

# Install node
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install operator-sdk
RUN RELEASE_VERSION=v1.0.1 && \
    curl -f -LO https://github.com/operator-framework/operator-sdk/releases/download/${RELEASE_VERSION}/operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu && \
    curl -f -LO https://github.com/operator-framework/operator-sdk/releases/download/${RELEASE_VERSION}/operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu.asc && \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-key 0CF50BEE7E4DF6445E08C0EA9AFDE59E90D2B445 && \
    gpg --batch --verify operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu.asc && \
    chmod +x operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu && \
    mkdir -p /usr/local/bin/ && \
    cp operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu /usr/local/bin/operator-sdk && \
    rm operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu

ENV PATH=${PATH}:/usr/local/go/bin
ENV GOROOT=/usr/local/go
ENV GOPATH=/go
ENV PATH=${PATH}:${GOPATH}/bin

# Install gh
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt update && \
    apt install --no-install-recommends -y gh && rm -rf /var/lib/apt/lists/*;
