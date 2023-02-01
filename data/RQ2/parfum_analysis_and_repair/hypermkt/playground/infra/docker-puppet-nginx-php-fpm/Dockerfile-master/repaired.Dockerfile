FROM asuforce/puppetserver

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends -qq git && rm -rf /var/lib/apt/lists/*;

ENV PATH $PATH:/opt/puppetlabs/puppet/bin/

WORKDIR /etc/puppetlabs/code/environments
RUN cp -r production development
ADD . development

WORKDIR /etc/puppetlabs/code/environments/development
RUN bundle install --path vendor/bundle
RUN bundle exec librarian-puppet install --path vendor/modules
