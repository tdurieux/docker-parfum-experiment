FROM circleci/ruby:2.5.3-stretch-node
# FROM circleci/ruby:2.7.1-buster-node

COPY . /app

RUN node -v
RUN ruby -v
RUN bundle -v

RUN apt-get update && apt-get install --no-install-recommends -y \
  graphviz \
  graphicsmagick-imagemagick-compat graphicsmagick-libmagick-dev-compat && rm -rf /var/lib/apt/lists/*;

RUN cd book/config && bundle install

CMD cd book/config && make VERSION="$(npx -c 'echo "$npm_package_version"')"
