FROM ruby:2.3.1
RUN apt-get update && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev libssh2-1 libssh2-1-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app
COPY . /app

WORKDIR /app

RUN bundle install

VOLUME /data/ssh

ENV GITHUB_SSH_KEY_PATH /data/ssh/ssh_key

CMD bundle exec rackup -s thin -o 0.0.0.0 -p 80 webhook.config.ru
