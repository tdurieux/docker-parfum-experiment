FROM ruby

WORKDIR /usr/src/app

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle

COPY . .

ENV EXECJS_RUNTIME Node

CMD bundle exec middleman server
