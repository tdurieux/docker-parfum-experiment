FROM golang:1.16

RUN apt-get update && apt-get -y --no-install-recommends install wget unzip && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp
RUN wget https://releases.hashicorp.com/terraform/0.12.31/terraform_0.12.31_linux_amd64.zip && unzip terraform_0.12.31_linux_amd64.zip -d /usr/local/bin


ENV GO111MODULE=on
WORKDIR /terraform-validator
COPY . .
RUN make build

ENTRYPOINT ["/terraform-validator/bin/terraform-validator"]
