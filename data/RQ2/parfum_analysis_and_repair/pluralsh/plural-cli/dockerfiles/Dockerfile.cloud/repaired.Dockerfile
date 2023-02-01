FROM golang:1.18-stretch

RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list && \
    apt-get update -y && apt-get install --no-install-recommends -y apt-transport-https ca-certificates gnupg unzip git openssl curl zsh emacs vim locales-all && \
    apt-get install --no-install-recommends -t stretch-backports -y tmux && rm -rf /var/lib/apt/lists/*;

ARG HELM_VERSION=3.7.0
ARG TERRAFORM_VERSION=1.0.7

# install kubectl, helm and terraform
# ENV BASE_URL="https://storage.googleapis.com/kubernetes-helm"
ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"

ARG KUBECTL_VERSION='1.22.1'
ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN curl -f -L ${BASE_URL}/${TAR_FILE} | tar xvz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/helm && \
    chmod +x /usr/local/bin/terraform && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl --help && terraform version && helm version

# install azure cli
RUN curl -f -sL https://aka.ms/InstallAzureCLIDeb | bash -s -- -y && \
      az --help

# install awscli
RUN curl -f https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
      unzip awscliv2.zip && \
      ./aws/install -i /usr/local/aws-cli -b /usr/local/bin && \
      aws --version

# install gcloud
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
      curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
      apt-get update -y && apt-get install --no-install-recommends -y google-cloud-sdk && \
      gcloud --help && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

ENV TERM=xterm-256color
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN git clone https://github.com/powerline/fonts.git --depth=1 && \
      sh fonts/install.sh && \
      rm -rf fonts

WORKDIR $GOPATH/src/plural/
RUN useradd -ms /bin/bash plural

COPY . .
RUN make build-cli OUTFILE=/go/bin/plural && \
      cp /go/bin/plural /usr/local/bin/plural && \
      plural --help && \
      cp start-session.sh /usr/local/bin/start-session.sh && \
      chmod +x /usr/local/bin/start-session.sh

WORKDIR /home/plural
USER plural

COPY tmux /home/plural/tmux
COPY welcome.txt /home/plural/welcome.txt
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \ 
      cp tmux/.tmux.conf /home/plural/.tmux.conf && \ 
      cp tmux/.tmux.conf.local /home/plural/.tmux.conf.local && \
      cat tmux/.zshrc.local >> /home/plural/.zshrc && \
      helm plugin install https://github.com/pluralsh/helm-push && \
      helm plugin install https://github.com/databus23/helm-diff

ENV GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
ENV GOOGLE_APPLICATION_CREDENTIALS=/home/plural/gcp.json
CMD eval $(ssh-agent -s); plural serve
