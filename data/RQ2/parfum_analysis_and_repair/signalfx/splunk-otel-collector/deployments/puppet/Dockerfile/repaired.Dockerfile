FROM ruby:2.6-buster

ENV PATH=$PATH:/opt/puppetlabs/bin:/opt/puppetlabs/pdk/bin

WORKDIR /tmp

RUN wget https://apt.puppetlabs.com/puppet6-release-buster.deb &&\
    dpkg -i puppet6-release-buster.deb &&\
    rm *.deb &&\
    apt update && \
    apt install --no-install-recommends -y puppet-agent && rm -rf /var/lib/apt/lists/*;

RUN wget https://apt.puppet.com/puppet-tools-release-buster.deb && \
    dpkg -i puppet-tools-release-buster.deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y pdk && \
    rm -f *.deb && rm -rf /var/lib/apt/lists/*;

WORKDIR /etc/puppetlabs/code/modules/splunk_otel_collector
COPY ./ ./
RUN gem install bundler && bundle install

RUN mkdir -p /root/.config/puppet && \
    echo "---\n\
disabled: true" > /root/.config/puppet/analytics.yml

ENV PATH=/opt/puppetlabs/bin:$PATH
