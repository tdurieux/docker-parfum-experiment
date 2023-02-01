FROM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum update -y; \
  yum install -y git unzip; rm -rf /var/cache/yum

# install aws-cli v2
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
  unzip awscliv2.zip && \
  ./aws/install

ADD githubsync.sh /root
ADD s3sync.sh /root
