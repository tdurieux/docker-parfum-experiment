# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This Dockerfile will build an image that is configured
# to use Fluentd to collect all Docker container log files
# and then cause them to be ingested using the Google Cloud
# Logging API. This configuration assumes that the host performning
# the collection is a VM that has been created with a logging.write
# scope and that the Logging API has been enabled for the project
# in the Google Developer Console.

FROM gcr.io/google_containers/ubuntu-slim:0.4

MAINTAINER Mik Vyatskov "vmik@google.com"

# Disable prompts from apt
ENV DEBIAN_FRONTEND noninteractive

# Install build tools
RUN apt-get -qq update && \
    apt-get install --no-install-recommends -y -qq curl ca-certificates gcc make bash sudo && \
    apt-get install --no-install-recommends -y -qq --reinstall lsb-base lsb-release && \
    # Install logging agent and required gems
    /usr/bin/curl -sSL https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent2.sh | sh && \
    sed -i -e "s/USER=td-agent/USER=root/" -e "s/GROUP=td-agent/GROUP=root/" /etc/init.d/td-agent && \
    td-agent-gem install --no-document fluent-plugin-record-reformer -v 0.8.2 && \
    td-agent-gem install --no-document fluent-plugin-systemd -v 0.0.5 && \
    td-agent-gem install --no-document fluent-plugin-google-cloud -v 0.5.2 && \
    # Remove build tools
    apt-get remove -y -qq gcc make && \
    apt-get autoremove -y -qq && \
    apt-get clean -qq && \
    # Remove unnecessary files
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
        /opt/td-agent/embedded/share/doc \
        /opt/td-agent/embedded/share/gtk-doc \
        /opt/td-agent/embedded/lib/postgresql \
        /opt/td-agent/embedded/bin/postgres \
        /opt/td-agent/embedded/share/postgresql \
        /etc/td-agent/td-agent.conf

# Copy the Fluentd configuration files for logging Docker container logs.
# Either configuration file can be used by specifying `-c <file>` as a command
# line argument.
COPY google-fluentd.conf /etc/td-agent/td-agent.conf
COPY google-fluentd-journal.conf /etc/td-agent/td-agent-journal.conf

# Start Fluentd to pick up our config that watches Docker container logs.
CMD /usr/sbin/td-agent $FLUENTD_ARGS
