FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
ADD fun_sftp.gemspec /app/fun_sftp.gemspec
ADD lib /app/lib
RUN bundle install
ADD . /app

