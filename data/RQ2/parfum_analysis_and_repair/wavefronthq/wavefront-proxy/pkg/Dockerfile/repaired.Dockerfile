# Create a docker VM for building the wavefront proxy agent .deb and .rpm
# packages.
FROM ruby:2.7

RUN gem install fpm
RUN gem install package_cloud
RUN apt-get update && apt-get install --no-install-recommends -y rpm && rm -rf /var/lib/apt/lists/*;
