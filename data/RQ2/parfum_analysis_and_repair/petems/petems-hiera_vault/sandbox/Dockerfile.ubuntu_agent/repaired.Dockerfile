FROM ubuntu:xenial
RUN apt-get update
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -o /tmp/puppet6-release-xenial.deb https://apt.puppetlabs.com/puppet6-release-xenial.deb
RUN dpkg -i /tmp/puppet6-release-xenial.deb
RUN apt-get update

# install puppet-agent (comes with puppet parser validate, which is what we want) and puppet-lint
RUN apt-get -y update && apt-get -y --no-install-recommends install puppet-agent puppet-lint && rm -rf /var/lib/apt/lists/*;

RUN cp /opt/puppetlabs/bin/puppet /bin/puppet