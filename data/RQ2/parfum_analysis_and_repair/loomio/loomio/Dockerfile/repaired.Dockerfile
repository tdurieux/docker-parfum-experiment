#
# Warning: this image is designed to be used with docker-compose as
# instructed at https://github.com/loomio/loomio-deploy
#
# It is not a standalone image.
#
FROM ruby:2.7.6
ENV REFRESHED_AT 2020-12-22
ENV BUNDLE_BUILD__SASSC=--disable-march-tune-native
ENV MALLOC_ARENA_MAX=2
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && rm -rf /root/.gem;
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential sudo apt-utils && rm -rf /var/lib/apt/lists/*;

# for activestorage previews
RUN apt-get install --no-install-recommends -y imagemagick ffmpeg mupdf libvips && rm -rf /var/lib/apt/lists/*;

# for postgres
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;

# for nokogiri
RUN apt-get install --no-install-recommends -y libxml2-dev libxslt1-dev && rm -rf /var/lib/apt/lists/*;

# for node
# RUN apt-get install -y python python-dev python-pip python-virtualenv

# install node
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN gem install bundler

# RUN mkdir /loomio
WORKDIR /loomio
ADD . /loomio
COPY config/database.docker.yml /loomio/config/database.yml
RUN bundle install

WORKDIR /loomio/vue
RUN npm install && npm cache clean --force;
RUN npm run build
WORKDIR /loomio

EXPOSE 3000

# source the config file and run puma when the container starts
CMD /loomio/docker_start.sh
