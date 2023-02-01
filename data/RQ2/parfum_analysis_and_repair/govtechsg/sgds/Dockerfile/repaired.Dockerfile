FROM ruby:2-slim

WORKDIR /usr/src/app

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

RUN bundle exec jekyll build

RUN apt-get install --no-install-recommends nginx -y && rm -rf /var/lib/apt/lists/*;

RUN cp -R ./_site/* /var/www/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
