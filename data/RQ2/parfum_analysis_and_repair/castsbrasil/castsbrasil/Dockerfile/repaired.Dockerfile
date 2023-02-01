FROM ruby:2.3.1

RUN curl -f -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get update -qq && apt-get install --no-install-recommends -y --force-yes build-essential \
    curl git vim nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /myapp

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
ADD bower.json bower.json
RUN bundle install
RUN npm install -g bower-installer && npm cache clean --force;
RUN bower-installer

WORKDIR /myapp
ADD . /myapp

CMD ["rails", "server", "-b" "0.0.0.0"]
