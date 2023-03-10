FROM ruby:2.5.1

MAINTAINER Darren Oakley <daz.oakley@gmail.com>

# Install PhantomJS and its dependencies - needed for the test suite
RUN apt-get update && \
  apt-get install --no-install-recommends -y build-essential chrpath libssl-dev libxft-dev && \
  apt-get install --no-install-recommends -y libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev && \
  cd /usr/local/share && \
  export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64" && \
  wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 && \
  tar xvjf $PHANTOM_JS.tar.bz2 && \
  ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/share/phantomjs && \
  ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin/phantomjs && \
  ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/bin/phantomjs && rm $PHANTOM_JS.tar.bz2 && rm -rf /var/lib/apt/lists/*;

# Copy Bandiera to the container
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY . $APP_HOME

# bundle
RUN gem install bundler --no-rdoc --no-ri
RUN bundle install --jobs 4

EXPOSE 5000

CMD [ "bundle exec guard -i -p -l 1" ]
