FROM ubuntu:18.04

RUN apt update && \
    apt install --no-install-recommends -y curl && \
    apt install -y --no-install-recommends coreutils && \
    apt install --no-install-recommends -y wget && \
    apt install --no-install-recommends -y unzip && \
    apt install --no-install-recommends -y jq && \
    apt install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

# install yq required for xform YAML to JSON
RUN apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:rmescandon/yq && \
    apt update && apt install --no-install-recommends -y yq && rm -rf /var/lib/apt/lists/*;

RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x kubectl
RUN wget https://releases.hashicorp.com/vault/1.4.2/vault_1.4.2_linux_amd64.zip && \
    unzip vault_1.4.2_linux_amd64.zip && \
    mkdir -p /usr/local/bin/ && \
    mv vault /usr/local/bin/ && \
    rm -f vault_1.4.2_linux_amd64.zip

# get a demo script from https://github.com/duglin/tools/tree/master/demoscript
# or https://github.com/mrsabath/tools/tree/master/demoscript
RUN curl -f -LO https://raw.githubusercontent.com/mrsabath/tools/master/demoscript/demoscript && \
   chmod +x demoscript && \
   mv demoscript /usr/local/bin

COPY demo.mars-s3.sh /usr/local/bin/demo-s3.sh
COPY demo.mars-vault.sh /usr/local/bin/demo-vault.sh

# adding Spire agent
RUN VERSION=1.0.2 && \
    wget https://github.com/spiffe/spire/releases/download/v${VERSION}/spire-${VERSION}-linux-x86_64-glibc.tar.gz && \
    tar zvxf spire-${VERSION}-linux-x86_64-glibc.tar.gz && \
    mkdir -p /opt/spire/bin && \
    mv /spire-${VERSION}/bin/spire-agent /opt/spire/bin/ && \
    rm -rf spire-${VERSION}/ && \
    rm -f spire-${VERSION}-linux-x86_64-glibc.tar.gz

# add AWS CLI
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
   unzip awscliv2.zip && \
   ./aws/install && \
   rm -rf aws && \
   rm -f awscliv2.zip

# setup env. variables for the demos:
ARG DEFAULT_AG_SOCK="/run/spire/sockets/agent.sock"
ARG DEFAULT_S3_AUD="mys3"
ARG DEFAULT_S3_ROLE="arn:aws:iam::581274594392:role/mars-mission-role-01"
ARG DEFAULT_S3_CMD="aws s3 cp s3://mars-spire/mars.txt top-secret.txt"
ARG DEFAULT_VAULT_AUD="vault"
ARG DEFAULT_VAULT_ROLE="mars-role"
ARG DEFAULT_VAULT_ADDR="http://vault-service"
ARG DEFAULT_VAULT_SECRET="/v1/secret/data/my-super-secret"
ARG DEFAULT_VAULT_DATA=".data.data"

ENV AG_SOCK=${DEFAULT_AG_SOCK}
ENV S3_AUD=${DEFAULT_S3_AUD}
ENV S3_ROLE=${DEFAULT_S3_ROLE}
ENV S3_CMD=${DEFAULT_S3_CMD}
ENV AULT_AUD=${DEFAULT_VAULT_AUD}
ENV VAULT_ROLE=${DEFAULT_VAULT_ROLE}
ENV VAULT_ADDR=${DEFAULT_VAULT_ADDR}
ENV VAULT_SECRET=${DEFAULT_VAULT_SECRET}
ENV VAULT_DATA=${DEFAULT_VAULT_DATA}

WORKDIR /usr/local/bin/

# run it forever
CMD ["/bin/bash", "-c", "tail -f /dev/null"]
