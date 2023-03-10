FROM ruby:2.6.3

RUN printf "deb http://deb.debian.org/debian/ stretch main\ndeb-src http://deb.debian.org/debian/ stretch main\ndeb http://security.debian.org stretch/updates main\ndeb-src http://security.debian.org stretch/updates main" > /etc/apt/sources.list

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs graphviz && rm -rf /var/lib/apt/lists/*;

ENV APP_HOME /app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME/
COPY Gemfile.lock $APP_HOME/

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/bundle
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && \
  gem install bundler --no-document --version $(tail -n 1 Gemfile.lock) | sed -e 's/^[[:space:]]*//' && \
  bundle install --system && rm -rf /root/.gem;

COPY . $APP_HOME/

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
