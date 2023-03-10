FROM internetee/ruby_base:3.0
LABEL org.opencontainers.image.source=https://github.com/internetee/registry

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle config set without 'development test' && bundle install --jobs 20 --retry 5