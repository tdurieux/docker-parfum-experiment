# Use the official lightweight Ruby image.
# https://hub.docker.com/_/ruby
FROM ruby:2.7-slim

# Install production dependencies.
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_FROZEN=true
RUN apt-get update && \
    apt-get install --no-install-recommends build-essential -y && \
    gem install bundler:1.17.3 google-cloud-storage && \
    bundle install --without test && \
    apt-get remove build-essential -y && rm -rf /var/lib/apt/lists/*;

# Copy local code to the container image.
COPY . ./

# Run the web service on container startup.
CMD ["ruby", "./app.rb"]
