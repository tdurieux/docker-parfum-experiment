FROM debian:jessie

ENV RACK_ENV production

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential ruby ruby-dev && \
    apt-get clean && \
    rm /var/lib/apt/lists/*_*

COPY Gemfile Gemfile.lock /app/
WORKDIR /app
RUN gem install bundler && \
    bundle install

COPY * /app/

ENTRYPOINT ["bundle", "exec", "ruby", "app.rb", "-p", "8080"]
