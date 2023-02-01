FROM ruby:2.5.1

# Install dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;

# Set working directory, where the commands will be ran:
RUN mkdir -p /var/www/app
WORKDIR /var/www/app

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 20 --retry 5

# Adding project files
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile

CMD [ "bundle", "exec", "puma", "-C", "config/puma.rb" ]
