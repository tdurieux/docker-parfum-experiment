FROM alpine:3.7
MAINTAINER Henning Jacobs <henning@jacobs1.de>

RUN apk add --no-cache python3 ca-certificates && \
    pip3 install --upgrade pip setuptools boto3 pykube Flask && \
    rm -rf /var/cache/apk/* /root/.cache /tmp/* 

WORKDIR /

COPY kube_aws_autoscaler /kube_aws_autoscaler

ARG VERSION=dev
RUN sed -i "s/__version__ = .*/__version__ = '${VERSION}'/" /kube_aws_autoscaler/__init__.py

ENTRYPOINT ["python3", "-m", "kube_aws_autoscaler"]
