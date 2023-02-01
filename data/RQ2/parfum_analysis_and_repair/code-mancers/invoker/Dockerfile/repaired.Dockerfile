FROM ruby:2.3

MAINTAINER hemant@codemancers.com

RUN apt-get update && apt-get -y --no-install-recommends install dnsmasq socat && rm -rf /var/lib/apt/lists/*;

CMD cd /invoker && bundle install --path vendor/ && bundle exec rake spec
