FROM golang:1.16.3-stretch
ARG TERRAFORM_VERSION
LABEL maintainer="Dotnet Mentor <info@dotnetmentor.se>"
RUN apt-get update && apt-get install --no-install-recommends -y git bash openssl curl unzip && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://github.com/goreleaser/goreleaser/releases/download/v0.162.0/goreleaser_Linux_x86_64.tar.gz > goreleaser_Linux_x86_64.tar.gz
RUN tar -xzf goreleaser_Linux_x86_64.tar.gz && mv goreleaser /bin/goreleaser && chmod +x /bin/goreleaser && rm goreleaser_Linux_x86_64.tar.gz && goreleaser --version
RUN curl -f -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && mv terraform /bin/terraform && chmod +x /bin/terraform && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && terraform --version
WORKDIR /work/
COPY go.mod .
COPY go.sum .
RUN go mod download
ENTRYPOINT ["/bin/bash"]
