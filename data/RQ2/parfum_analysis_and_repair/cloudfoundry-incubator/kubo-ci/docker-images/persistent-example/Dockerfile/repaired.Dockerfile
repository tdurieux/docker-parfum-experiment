FROM ruby:2.4.1

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
COPY . $APP_HOME

# Start server
ENV PORT 3000
EXPOSE 3000
CMD ["ruby", "app.rb"]
