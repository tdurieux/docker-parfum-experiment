FROM ruby:2.7.3

# Install additional packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        calibre \
        default-mysql-client \
        phantomjs \
        pwgen \
        shared-mime-info \
        wkhtmltopdf \
        zip && rm -rf /var/lib/apt/lists/*;

# Clean and mount repository at /otwa
RUN rm -rf /otwa && mkdir -p /otwa
WORKDIR /otwa
VOLUME /otwa

# Install ruby packages
COPY Gemfile .
COPY Gemfile.lock .
RUN gem install bundler -v 1.17.3 && bundle install

# Default command to run in a new container
EXPOSE 3000
CMD bundle exec rails s -p 3000
