# this was taken from http://github.com/openstack/fuel-ccp-rabbitmq
#
FROM debian:jessie
MAINTAINER stackanetes

{% set erlang_deps = 'libwxbase3.0-0 libwxgtk3.0-0' %}
{% set rabbit_build_deps = 'zip xsltproc xmlto unzip python-simplejson make git rsync dpkg-dev debhelper dh-systemd build-essential python-pip curl' %}
{% set rabbit_run_deps = 'socat logrotate' %}


RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  {{ erlang_deps }} {{ rabbit_build_deps }} {{ rabbit_run_deps }} && rm -rf /var/lib/apt/lists/*;

RUN curl -f --insecure --silent --show-error -Lo /tmp/erlang.deb https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_18.3.4-1~debian~jessie_amd64.deb \
 && dpkg -i /tmp/erlang.deb \
 && rm -f /tmp/erlang.deb

# We need at least ver 3.6.6 for this patch https://github.com/rabbitmq/rabbitmq-server/pull/892
RUN curl -f -Lo /tmp/rabbitmq-server.deb https://github.com/rabbitmq/rabbitmq-server/releases/download/rabbitmq_v3_6_6_milestone5/rabbitmq-server_3.6.5.905-1_all.deb \
  && dpkg -i /tmp/rabbitmq-server.deb \
  && rm -rf /tmp/rabbitmq-server.deb /var/lib/rabbitmq/*


COPY fetch-from-github /fetch-from-github

# Build and install autocluster plugin from source
RUN /fetch-from-github binarin   rabbitmq-autocluster startup-locking-support-rc2              /tmp/ac \
 && /fetch-from-github rabbitmq  rabbitmq-server      rabbitmq_v3_6_6_milestone5 /tmp/ac/deps/rabbit \
 && /fetch-from-github rabbitmq  rabbitmq-common      rabbitmq_v3_6_6_milestone5 /tmp/ac/deps/rabbit_common \
 && /fetch-from-github gmr       rabbitmq-aws         master /tmp/ac/deps/rabbitmq_aws \
 && /fetch-from-github rabbitmq  rabbitmq-codegen     rabbitmq_v3_6_6_milestone5 /tmp/ac/deps/rabbitmq_codegen \
 && /fetch-from-github ninenines ranch                a5d2efcde9a34ad38ab89a26d98ea5335e88625a /tmp/ac/deps/ranch \
 && make -C /tmp/ac \
 && make -C /tmp/ac dist IGNORE_DEPS=rabbit \
 && cp -v /tmp/ac/plugins/autocluster-*.ez /tmp/ac/plugins/rabbitmq_aws-*.ez /usr/lib/rabbitmq/lib/rabbitmq_server-*/plugins/ \
 && rm -rf /tmp/ac


COPY start.sh /start-rabbit
RUN usermod -a -G rabbitmq rabbitmq \
    && chown -R rabbitmq: /var/lib/rabbitmq /var/log/rabbitmq /etc/rabbitmq

USER rabbitmq
COPY kubernetes-entrypoint /kubernetes-entrypoint
ENTRYPOINT ["/kubernetes-entrypoint"]
