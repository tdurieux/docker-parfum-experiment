FROM ruby:2
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
ENV BUNDLER_VERSION 1.17.3
RUN gem install bundler -v ${BUNDLER_VERSION} && bundle install --jobs 20 --retry 5
ADD . /myapp
CMD /myapp/bin/rails s -b 0.0.0.0 -p 3010
EXPOSE 3010
