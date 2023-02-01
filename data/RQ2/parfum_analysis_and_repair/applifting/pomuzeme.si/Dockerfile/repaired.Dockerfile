FROM ruby:2.6.3

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;

RUN gem install bundler

ENV RAILS_ENV production
ENV RACK_ENV production
WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install

COPY . .

RUN RAILS_ENV=production SECRET_KEY_BASE=dummy bundle exec rake assets:precompile
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
