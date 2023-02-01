FROM ruby
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /api
WORKDIR /api
ADD api/Gemfile /api/Gemfile
ADD api/Gemfile.lock /api/Gemfile.lock
RUN bundle install
ADD api /api
ADD docker/dev /docker
ADD .git /.git