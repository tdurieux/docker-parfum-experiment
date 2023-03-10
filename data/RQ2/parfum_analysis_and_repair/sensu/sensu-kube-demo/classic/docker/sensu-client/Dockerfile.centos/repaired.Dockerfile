FROM centos:7 as builder
WORKDIR /home
RUN \
  curl -f -LO https://github.com/sensu/sensu-prometheus-collector/releases/download/1.1.4/sensu-prometheus-collector_1.1.4_linux_amd64.tar.gz && \
  tar -xzf sensu-prometheus-collector_1.1.4_linux_amd64.tar.gz && \
  cp bin/sensu-prometheus-collector /usr/bin/sensu-prometheus-collector && rm sensu-prometheus-collector_1.1.4_linux_amd64.tar.gz

FROM sensu/sensu-classic:1.5.0-1
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm && \
  yum install -y nagios-plugins-http && rm -rf /var/cache/yum
COPY --from=builder /usr/bin/sensu-prometheus-collector /usr/bin/sensu-prometheus-collector
