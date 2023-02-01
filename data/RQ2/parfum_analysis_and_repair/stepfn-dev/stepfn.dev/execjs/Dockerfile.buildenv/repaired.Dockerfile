FROM public.ecr.aws/amazonlinux/amazonlinux:2
RUN yum install -y go gcc-c++ && rm -rf /var/cache/yum
