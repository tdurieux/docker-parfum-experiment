FROM public.ecr.aws/amazonlinux/amazonlinux:2

RUN amazon-linux-extras enable docker && \
    yum clean metadata && \
    yum install -y docker tar && rm -rf /var/cache/yum
