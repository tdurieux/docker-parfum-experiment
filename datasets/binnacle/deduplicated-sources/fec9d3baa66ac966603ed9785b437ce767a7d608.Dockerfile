FROM ruby:2.2.2

RUN apt-get update
RUN apt-get -y install node

EXPOSE 3000
ENV PORT 3000

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

COPY . /app

CMD ["rails", "server", "-b", "0.0.0.0"]
