FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim

ARG VERSION=1.0.7

RUN apt install --no-install-recommends unzip -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip -o terraform.zip
RUN unzip terraform.zip && rm terraform.zip
RUN mv terraform /usr/bin