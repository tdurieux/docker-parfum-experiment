# Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.

# Description:
# This Dockerfile was generated from the template at templates/Dockerfile.j2

{%   set kibana_url = 'https://artifacts.elastic.co/downloads/kibana' -%}
{%   set url_root = artifacts_url -%}
{%   set plugins = plugins -%}
{%   set tarball = 'kibana-oss-%s-linux-x86_64.tar.gz' % es_version -%}

FROM centos:7

ENV ELASTIC_CONTAINER true

RUN yum update -y && yum install -y fontconfig freetype && yum clean all && rm -rf /var/cache/yum

WORKDIR /usr/share/kibana

ENV PATH=/usr/share/kibana/bin:$PATH

RUN rm -rf /tmp/plugins && mkdir /tmp/plugins

ADD plugins /tmp/plugins/

RUN curl -f -Ls {{ kibana_url }}/{{ tarball }} | tar --strip-components=1 -zxf - && \
    for plugin in `cat /tmp/plugins/plugins_kibana.list`; do \
        kibana-plugin install --allow-root file:/tmp/plugins/$plugin ; \
    done && \
    rm -rf /tmp/plugins/ && \
    ln -s /usr/share/kibana /opt/kibana && \
    chown -R 1000:0 . && \
    chmod -R g=u /usr/share/kibana && \
    find /usr/share/kibana -type d -exec chmod g+s {} \;

# Set some Kibana configuration defaults.
COPY --chown=1000:0 config/kibana.yml /usr/share/kibana/config/kibana.yml

# Add the launcher/wrapper script. It knows how to interpret environment
# variables and translate them to Kibana CLI options.
COPY --chown=1000:0 bin/kibana-docker /usr/local/bin/

# Add a self-signed SSL certificate for use in examples.
COPY --chown=1000:0 ssl/opendistroforelasticsearch.example.org.* /usr/share/kibana/config/

# Ensure gid 0 write permissions for Openshift.
# Provide a non-root user to run the process.
# Adds CENTOS License text.
RUN find /usr/share/kibana -gid 0 -and -not -perm /g+w -exec chmod g+w {} \; && \
    groupadd --gid 1000 kibana && \
      useradd --uid 1000 --gid 1000 \
      --home-dir /usr/share/kibana --no-create-home kibana && \
      echo $'= CentOS Licensing and Source Code =\n\nThis image is built from CentOS and DockerHub\'s official build of CentOS (https://hub.docker.com/_/centos). Their image contains various Open Source licensed packages and their DockerHub home page provides information on licensing.\n\nYou can list the packages installed in the image by running \'rpm -qa\', and you can download the source code for the packages CentOS and DockerHub provide via the yumdownloader tool.' > /root/CENTOS_LICENSING.txt

USER 1000

LABEL org.label-schema.schema-version="1.0" \
  org.label-schema.vendor="Amazon" \
  org.label-schema.name="opendistroforelasticsearch-kibana" \
  org.label-schema.version="{{ version_tag }}" \
  org.label-schema.url="https://opendistro.github.io" \
  org.label-schema.vcs-url="https://github.com/opendistro-for-elasticsearch/opendistro-build" \
  org.label-schema.license="Apache-2.0" \
  org.label-schema.build-date="{{ build_date }}"

EXPOSE 5601

CMD ["/usr/local/bin/kibana-docker"]
