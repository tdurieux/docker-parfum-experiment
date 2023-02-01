FROM ruby:2

# install git iproute2, process tools
RUN apt-get update && apt-get -y --no-install-recommends install git iproute2 procps && rm -rf /var/lib/apt/lists/*;

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install jekyll
RUN gem install github-pages
