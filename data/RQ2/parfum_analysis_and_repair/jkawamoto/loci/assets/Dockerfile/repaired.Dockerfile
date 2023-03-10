#
# Dockerfile
#
# Copyright (c) 2016-2017 Junpei Kawamoto
#
# This software is released under the MIT License.
#
# http://opensource.org/licenses/mit-license.php
#
{{define "base"}}
FROM {{.BaseImage}}
MAINTAINER Junpei Kawamoto <kawamoto.junpei@gmail.com>

ENV TERM vt100
ENV DEBIAN_FRONTEND noninteractive
{{with .HTTPProxy}}
ENV HTTP_PROXY {{.}}
{{end}}
{{with .HTTPSProxy}}
ENV HTTPS_PROXY {{.}}
{{end}}
{{with .NoProxy}}
ENV NO_PROXY {{.}}
{{end}}
ENV TRAVIS_OS_NAME linux

{{with .AptProxy}}
RUN echo "Acquire::http { Proxy \"{{.}}\"; };" >> /etc/apt/apt.conf.d/01proxy
{{end}}

{{with .PypiProxy}}
RUN PYPI_PROXY={{.}} && \
    IPPORT=${PYPI_PROXY#*//} && \
    mkdir -p ~/.pip/ && \
    echo "[global]\nindex-url=$PYPI_PROXY/root/pypi\ntrusted-host=${IPPORT%:*}" >> ~/.pip/pip.conf
{{end}}

# Install Common APT packages.
RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-utils git curl wget sudo unzip ccache pkg-config xvfb libgtk2.0-dev freeglut3-dev && \
    rm -rf /var/lib/apt/lists/*
# Install language specific packages.
{{block "package" .}}
{{end}}
# Install runtimes to be used in tests.
ARG VERSION
{{block "version" .}}
{{end}}
# Install required packages.
{{if .Travis.Addons.Apt.Packages}}
RUN apt-get update && \
    apt-get install --no-install-recommends -y {{range .Travis.Addons.Apt.Packages}} {{.}} {{end}} && \
    rm -rf /var/lib/apt/lists/*
{{end}}

{{block "source" .}}
ADD {{.Archive}} /data
WORKDIR /data
{{end}}

ADD entrypoint.sh /root
ENTRYPOINT ["bash", "/root/entrypoint.sh"]
{{end}}
