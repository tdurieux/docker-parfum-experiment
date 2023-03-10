FROM ruby:latest

# fixes cucumber bug where it cannot find bundler
RUN gem install bundler --no-ri --no-rdoc

RUN mkdir -p /usr/src/lib && rm -rf /usr/src/lib
WORKDIR /usr/src/lib

COPY Gemfile* /usr/src/lib/
COPY *.gemspec /usr/src/lib/
RUN bundle install

COPY Appraisals /usr/src/lib/
RUN appraisal install

COPY . /usr/src/lib/
