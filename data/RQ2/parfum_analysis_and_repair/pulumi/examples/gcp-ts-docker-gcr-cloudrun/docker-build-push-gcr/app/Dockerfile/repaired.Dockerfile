# Use the official lightweight Ruby image.
FROM ruby:2.7-slim

# Install production dependencies.
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_FROZEN=true
RUN bundle install

# Copy local code to the container image.
COPY . ./

# Run the web service on container startup.