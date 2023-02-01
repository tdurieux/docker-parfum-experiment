FROM asuforce/puppet

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends -qq git && rm -rf /var/lib/apt/lists/*;

ADD . /etc/puppet

WORKDIR /etc/puppet
RUN bundle install --path vendor/bundle
RUN bundle exec librarian-puppet install
