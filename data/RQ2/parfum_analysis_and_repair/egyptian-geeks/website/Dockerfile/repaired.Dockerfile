FROM ruby:2.6.6
ENV LANG=C.UTF-8
ENV RAILS_ENV production

RUN apt update && apt install --no-install-recommends -qq -y build-essential nodejs libpq-dev postgresql-client npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;

WORKDIR /tmp
COPY Gemfile* /tmp/
RUN bundle install --without="development test" -j8

WORKDIR /
RUN mkdir -p /app/tmp/pids
ADD . /app

WORKDIR /app
RUN yarn install && yarn cache clean;
RUN rails assets:precompile

CMD puma -C config/puma.rb
