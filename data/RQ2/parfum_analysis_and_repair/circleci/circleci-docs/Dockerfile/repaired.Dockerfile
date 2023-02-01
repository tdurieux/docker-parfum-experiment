FROM ruby:2.7.4

RUN apt update -y && apt-get install --no-install-recommends -y cmake pkg-config && rm -rf /var/lib/apt/lists/*;
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install
RUN bundle exec jekyll clean

CMD ["bundle", "exec", "jekyll", "serve", "-s", "jekyll", "--incremental", "--host=0.0.0.0"]
