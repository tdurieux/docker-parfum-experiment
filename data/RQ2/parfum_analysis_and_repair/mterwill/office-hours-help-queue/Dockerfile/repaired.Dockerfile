FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir /usr/src/eecshelp && rm -rf /usr/src/eecshelp
WORKDIR /usr/src/eecshelp
ADD Gemfile /usr/src/eecshelp/Gemfile
ADD Gemfile.lock /usr/src/eecshelp/Gemfile.lock
RUN bundle install
ADD . /usr/src/eecshelp
ENTRYPOINT ["/usr/src/eecshelp/script/wait-for-it.sh", "-t", "60", "db:3306", "--"]
