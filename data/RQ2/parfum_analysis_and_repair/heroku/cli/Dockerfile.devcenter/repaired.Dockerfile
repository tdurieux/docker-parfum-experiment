FROM circleci/ruby:2.4-node

# Get less (devcenter needs it)
USER  root
RUN sudo apt-get update && apt-get install --no-install-recommends -y curl less && rm -rf /var/lib/apt/lists/*;
USER  circleci

# Install devcenter
RUN   gem install devcenter --no-document

# Remove old gems
RUN   gem cleanup
