FROM ruby:2.4.6

ARG BUNDLE_GEMS__CONTRIBSYS__COM
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN update-ca-certificates

# RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y build-essential nodejs libarchive-dev libpq-dev \
       postgresql-client cmake tidy git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY Gemfile* $APP_HOME/
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system && rm -rf /root/.gem;
RUN gem install bundler --version '>= 1.16.1' --conservative
RUN bundle install

COPY . $APP_HOME
