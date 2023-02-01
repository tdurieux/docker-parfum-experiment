FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;

RUN mkdir /alfred
WORKDIR /alfred

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . ./

COPY . /alfred

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

# Lines taken here : https://blog.codeship.com/running-rails-development-environment-docker/
