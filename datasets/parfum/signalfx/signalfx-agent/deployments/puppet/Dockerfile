FROM ubuntu:18.04

ENV PATH=$PATH:/opt/puppetlabs/bin:/opt/puppetlabs/pdk/bin

WORKDIR /tmp
RUN apt update &&\
    apt install -y make wget vim gcc ruby ruby-dev libxml2 libxml2-dev libxslt1-dev git apt-transport-https ca-certificates g++

RUN wget https://apt.puppetlabs.com/puppet5-release-bionic.deb &&\
    dpkg -i puppet5-release-bionic.deb &&\
    rm *.deb &&\
    apt update &&\
    apt install -y puppet-agent

RUN wget -O pdk.deb 'https://pm.puppetlabs.com/cgi-bin/pdk_download.cgi?dist=ubuntu&rel=18.04&arch=amd64&ver=latest' &&\
    dpkg -i pdk.deb &&\
	rm *.deb

WORKDIR /etc/puppetlabs/code/modules/signalfx_agent
COPY ./Rakefile ./Gemfile ./Gemfile.lock ./
RUN gem install bundler -v "$(grep -A1 'BUNDLED WITH' Gemfile.lock | tail -n1)" && bundle install

ENV PATH=/opt/puppetlabs/bin:$PATH

COPY ./ ./
