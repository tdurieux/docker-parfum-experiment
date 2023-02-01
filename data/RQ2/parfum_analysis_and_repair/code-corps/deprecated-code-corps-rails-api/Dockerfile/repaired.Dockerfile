FROM ruby:2.2.5
  RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system 2.6.1 && rm -rf /root/.gem;
RUN gem install bundler --version $BUNDLER_VERSION

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# ImageMagick
RUN apt-get install --no-install-recommends -y imagemagick && rm -rf /var/lib/apt/lists/*;

# PostgreSQL
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;

# Node.js runtime
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Set directory for our app
ENV APP_HOME /code-corps-api
RUN mkdir $APP_HOME

# Copy Gemfile and bundle
WORKDIR $APP_HOME
COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock
RUN bundle install

# Copy code
ADD . $APP_HOME
