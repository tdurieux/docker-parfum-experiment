FROM ruby:2.7.3

ARG cert_dir=./certs

COPY ${cert_dir}/ /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN apt-get update && apt-get install --no-install-recommends -y default-libmysqlclient-dev nodejs npm netcat tzdata git chromium && npm install -g yarn && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

RUN yarn config set cafile /etc/ssl/certs/ca-certificates.crt && yarn cache clean;

COPY Gemfile Gemfile.lock yarn.lock /
RUN gem install bundler
RUN bundle install --jobs $(nproc)
RUN yarn install && yarn cache clean;
ENV RAILS_LOG_TO_STDOUT true
