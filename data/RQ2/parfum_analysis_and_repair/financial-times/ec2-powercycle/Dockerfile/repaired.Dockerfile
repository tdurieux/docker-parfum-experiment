FROM python:3.7-alpine

RUN apk add --no-cache --update \
    bash \
    build-base \
    curl \
    gcc \
    git \
    jq \
    libffi-dev \
    openssl-dev \
    python3-dev \
    util-linux \
    zip

RUN pip3 install --no-cache-dir awscli

ADD ./sh/*.sh /sh/

CMD /bin/bash sh/package.sh && /bin/bash sh/lambda-deploy-latest.sh --file ec2-powercycle.zip && /bin/bash sh/lambda-invoke-function.sh ec2-powercycle DryRun
