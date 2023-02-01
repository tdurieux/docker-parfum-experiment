FROM amazonlinux:latest

ENV RUNTIME=node
ENV VERSION=14.18.*

# Install node and zip
RUN curl -f -sL https://rpm.nodesource.com/setup_14.x | bash -
RUN yum -y update && yum -y install nodejs-${VERSION} zip bzip2-devel && rm -rf /var/cache/yum

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
