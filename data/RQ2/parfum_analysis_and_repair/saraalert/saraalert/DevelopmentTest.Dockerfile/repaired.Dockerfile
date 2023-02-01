FROM ruby:2.7.3

ARG cert

RUN echo "${cert}" > /usr/local/share/ca-certificates/ca-certificates.crt
RUN update-ca-certificates

RUN apt-get update && apt-get install --no-install-recommends -y default-libmysqlclient-dev nodejs npm tzdata git chromium && npm install -g yarn && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

RUN yarn config set cafile /etc/ssl/certs/ca-certificates.crt && yarn cache clean;

COPY Gemfile Gemfile.lock /
RUN gem install bundler
RUN bundle install --jobs $(nproc)
ENV RAILS_LOG_TO_STDOUT true
