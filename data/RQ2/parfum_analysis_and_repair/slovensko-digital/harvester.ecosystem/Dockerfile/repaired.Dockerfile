FROM ruby:2.7.2

# Install packages
RUN apt-get update && apt-get install --no-install-recommends -y build-essential nodejs libpq-dev && rm -rf /var/lib/apt/lists/*;

# Set working directory
RUN mkdir /app
WORKDIR /app

# Bundle and cache Ruby gems
COPY Gemfile* ./
RUN bundle config set deployment true
RUN bundle config set without development:test
RUN bundle install

# Cache everything
COPY . .

# Run application by default
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
