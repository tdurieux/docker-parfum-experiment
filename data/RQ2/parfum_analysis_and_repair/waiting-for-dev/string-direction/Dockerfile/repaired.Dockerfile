FROM ruby:2.4.3
ENV APP_HOME /app/
ENV LIB_DIR lib/string-direction/
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev libxml2-dev libxslt1-dev nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p $APP_HOME/$LIB_DIR
WORKDIR $APP_HOME
COPY Gemfile *gemspec $APP_HOME
COPY $LIB_DIR/version.rb $APP_HOME/$LIB_DIR
RUN bundle install
