FROM  amazonlinux:2
LABEL maintainer="tech-ally@lacework.net" \
      description="The Lacework CLI helps you manage the Lacework cloud security platform"

RUN yum update -y
RUN yum install -y gzip tar && rm -rf /var/cache/yum
COPY ./LICENSE /
RUN curl -f https://raw.githubusercontent.com/lacework/go-sdk/main/cli/install.sh | bash
