ARG AMAZON_LINUX_VERSION
FROM amazonlinux:${AMAZON_LINUX_VERSION}

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app

RUN set -x \
  && yum install -y python27 python27-pip \
  && pip-2.7 install .

ENTRYPOINT ["cfn-cli"]
