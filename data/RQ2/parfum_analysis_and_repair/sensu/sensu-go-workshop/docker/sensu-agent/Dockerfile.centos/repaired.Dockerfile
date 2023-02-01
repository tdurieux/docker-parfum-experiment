FROM centos:7
ARG SENSU_VERSION=6.2.7
ARG SENSU_PLATFORM=linux
ARG SENSU_ARCH=amd64
RUN \
  yum install -y curl ca-certificates && \
  curl -f -LO https://s3-us-west-2.amazonaws.com/sensu.io/sensu-go/${SENSU_VERSION}/sensu-go_${SENSU_VERSION}_${SENSU_PLATFORM}_${SENSU_ARCH}.tar.gz && \
  tar -xzf sensu-go_${SENSU_VERSION}_${SENSU_PLATFORM}_${SENSU_ARCH}.tar.gz -C /usr/bin/ && \
  rm sensu-go_${SENSU_VERSION}_${SENSU_PLATFORM}_${SENSU_ARCH}.tar.gz && rm -rf /var/cache/yum
CMD ["sensu-agent", "start"]
