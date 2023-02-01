FROM ruby:2.3.4-slim

LABEL maintainer="AASM"

ENV DEBIAN_FRONTEND noninteractive

# ~~~~ System locales ~~~~
RUN apt-get update && apt-get install --no-install-recommends -y locales && \
    dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8 && \
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
    locale-gen && rm -rf /var/lib/apt/lists/*;

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV APP_HOME /application

# ~~~~ Application dependencies ~~~~
RUN apt-get update
RUN apt-get install --no-install-recommends -y libsqlite3-dev \
                       build-essential \
                       git && rm -rf /var/lib/apt/lists/*;

# ~~~~ Bundler ~~~~
RUN gem install bundler

WORKDIR $APP_HOME
RUN mkdir -p $APP_HOME/lib/aasm/

COPY Gemfile* $APP_HOME/
COPY *.gemspec $APP_HOME/
COPY lib/aasm/version.rb $APP_HOME/lib/aasm/

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=8 \
  BUNDLE_PATH=/bundle

RUN bundle install

# ~~~~ Import application ~~~~
COPY . $APP_HOME
