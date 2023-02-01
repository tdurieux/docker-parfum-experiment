FROM ruby:2.2.3
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN mkdir /playground
WORKDIR /playground
ADD . /playground
ADD Gemfile /playground/Gemfile
ADD Gemfile.lock /playground/Gemfile.lock
RUN bundle install
RUN apt-get update && \
    apt-get -y --no-install-recommends install nginx && \
    apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

RUN bundle exec jekyll build --destination /var/www/html/playground
CMD nginx -g 'daemon off;'
