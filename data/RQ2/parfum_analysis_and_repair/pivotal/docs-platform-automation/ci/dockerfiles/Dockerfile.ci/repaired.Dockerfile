FROM golang:latest

RUN apt-get -y update && apt-get -y --no-install-recommends install rsync build-essential bash zip unzip curl gettext jq python3-pip python3-dev git wget tar xz-utils && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip

RUN wget "https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.x86_64.tar.xz" && \
    tar --xz -xvf shellcheck-stable.linux.x86_64.tar.xz && \
    cp shellcheck-stable/shellcheck /usr/bin/ && rm shellcheck-stable.linux.x86_64.tar.xz

RUN wget "https://dl.minio.io/server/minio/release/linux-amd64/minio" && \
    chmod +x minio && \
    mv minio /usr/bin/minio

RUN wget "https://dl.minio.io/client/mc/release/linux-amd64/mc" && \
    chmod +x mc && \
    mv mc /usr/bin/mc

RUN wget https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip && \
    unzip terraform_1.0.11_linux_amd64.zip -d /usr/bin

# install BOSH
RUN wget "https://github.com/cloudfoundry/bosh-cli/releases/download/v6.2.1/bosh-cli-6.2.1-linux-amd64" -O bosh
RUN chmod +x ./bosh && \
    mv ./bosh /usr/bin/bosh

# install credhub
RUN wget "https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.6.2/credhub-linux-2.6.2.tgz" -O credhub.tgz
RUN tar xzf credhub.tgz && rm credhub.tgz
RUN chmod +x ./credhub && \
    mv ./credhub /usr/bin/credhub

# install fly
RUN wget "https://platform-automation.ci.cf-app.com/api/v1/cli?arch=amd64&platform=linux" -O fly
RUN chmod +x ./fly && \
    mv ./fly /usr/bin/fly

# install https://github.com/sclevine/yj
RUN wget "https://github.com/sclevine/yj/releases/download/v4.0.0/yj-linux" -O yj
RUN chmod +x ./yj && \
    mv ./yj /usr/bin/yj

# install om
RUN git clone https://github.com/pivotal-cf/om
RUN cd om && \
    go build . && \
    mv om /usr/bin/ && \
    cd -

# rspec
RUN apt-get -y --no-install-recommends install ruby ruby-dev && \
    echo "gem: --no-document" >> /etc/gemrc && \
    gem install rspec english bundler && rm -rf /var/lib/apt/lists/*;

# uaac
RUN gem install cf-uaac

# used by `delete-terraformed-ops-manager`
RUN pip3 install --no-cache-dir awscli

# govc
#RUN go install github.com/vmware/govmomi/govc@latest

# govc binary
RUN wget https://github.com/vmware/govmomi/releases/latest/download/govc_Linux_x86_64.tar.gz && \
    tar xvfz govc_Linux_x86_64.tar.gz -C  /usr/local/bin govc

# openstack
RUN pip3 install --no-cache-dir python-openstackclient

# gcloud
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-bionic main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get -y update && apt-get -y install --no-install-recommends google-cloud-sdk && rm -rf /var/lib/apt/lists/*;

# azure
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN curl -f -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN apt-get install -y --no-install-recommends apt-transport-https && apt-get update && apt-get install -y --no-install-recommends azure-cli && rm -rf /var/lib/apt/lists/*;


RUN git config --global user.name "platform-automation"
RUN git config --global user.email "platformautomation@groups.vmware.com"

# used by test
RUN go install github.com/onsi/ginkgo/ginkgo@latest

# use to cleanup IAASes
RUN wget -O /usr/bin/leftovers "https://github.com/genevieve/leftovers/releases/download/v0.59.0/leftovers-v0.59.0-linux-amd64"
RUN chmod +x /usr/bin/leftovers

ENV CGO_ENABLED=0
