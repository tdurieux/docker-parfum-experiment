# This is an opinionated prometheus setup to monitor a Coda Service Environment
FROM ubuntu:18.04

# Dependencies
RUN apt-get -y update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
    python3-pip \
    curl \
    dumb-init && rm -rf /var/lib/apt/lists/*;

WORKDIR /prometheus
# Prometheus Setup
RUN useradd --no-create-home --shell /bin/false prometheus && \
    mkdir /etc/prometheus && \
    mkdir /var/lib/prometheus && \
    chown prometheus:prometheus /etc/prometheus && \
    chown prometheus:prometheus /var/lib/prometheus && \
    chown prometheus:prometheus /prometheus

RUN curl -f -LO https://github.com/prometheus/prometheus/releases/download/v2.11.1/prometheus-2.11.1.linux-amd64.tar.gz
RUN tar xvf prometheus-2.11.1.linux-amd64.tar.gz && rm prometheus-2.11.1.linux-amd64.tar.gz
RUN cp prometheus-2.11.1.linux-amd64/prometheus /usr/local/bin/ && \
    cp prometheus-2.11.1.linux-amd64/promtool /usr/local/bin/ && \
    chown prometheus:prometheus /usr/local/bin/prometheus && \
    chown prometheus:prometheus /usr/local/bin/promtool

RUN cp -r prometheus-2.11.1.linux-amd64/consoles /etc/prometheus && \
    cp -r prometheus-2.11.1.linux-amd64/console_libraries /etc/prometheus && \
    chown -R prometheus:prometheus /etc/prometheus/consoles && \
    chown -R prometheus:prometheus /etc/prometheus/console_libraries

RUN rm -rf  prometheus-2.11.1.linux-amd64.tar.gz  prometheus-2.11.1.linux-amd64

RUN pip3 install --no-cache-dir j2cli
COPY prometheus.j2 prometheus.j2
COPY entrypoint.sh entrypoint.sh

USER prometheus
CMD [ "bash", "entrypoint.sh" ]

