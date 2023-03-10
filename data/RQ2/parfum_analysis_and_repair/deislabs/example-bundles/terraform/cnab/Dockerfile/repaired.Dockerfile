FROM alpine:latest

ENV TERRAFORM_VERSION=0.11.8
ENV TERRAFORM_SHA256SUM=f991039e3822f10d6e05eabf77c9f31f3831149b52ed030775b6ec5195380999

RUN apk add --no-cache --update git curl openssh bash-completion && \
    curl -f https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    apk update && \
    apk add --no-cache bash py-pip && \
    apk add --no-cache --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev make && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir azure-cli

COPY Dockerfile /cnab/Dockerfile
COPY app /cnab/app

RUN chmod 755 /cnab/app/run
RUN chmod 755 /cnab/app/init-backend

CMD ["/cnab/app/run"]