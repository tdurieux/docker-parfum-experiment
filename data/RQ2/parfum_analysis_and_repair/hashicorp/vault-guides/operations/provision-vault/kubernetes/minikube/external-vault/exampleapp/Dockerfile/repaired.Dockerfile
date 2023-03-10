FROM ruby:2.6.2

RUN apt-get update && \
    apt-get install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;

# Install gems
ENV APP_HOME /app
ENV HOME /root
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
RUN bundle install

# Upload source
COPY config.ru $APP_HOME
RUN mkdir $APP_HOME/lib
COPY lib/* $APP_HOME/lib

# Start server
ENV PORT 8080
EXPOSE 8080
CMD ["rackup", "--port", "8080", "--env", "production" ]