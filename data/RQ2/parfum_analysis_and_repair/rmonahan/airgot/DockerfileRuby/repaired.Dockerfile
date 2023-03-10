FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler -v 2.0.1
RUN mkdir -p /app/backend
WORKDIR /app/backend
COPY . /app
COPY Gemfile /app/backend/Gemfile
RUN bundle install
COPY . /app/backend
EXPOSE 3001
CMD rails s -p 3001 -b '0.0.0.0'