# Dockerfile
FROM ruby:2.5
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libmysqlclient-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends sqlite3 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libssl-dev libyaml-dev libsqlite3-dev autoconf libgmp-dev libgdbm-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libncurses5-dev automake libtool bison pkg-config libffi-dev -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir /railsapp
RUN echo 'gem: --no-document' >> ~/.gemrc
EXPOSE 3000
WORKDIR /railsapp
ADD Gemfile /railsapp/Gemfile
ADD Gemfile.lock /railsapp/Gemfile.lock
RUN bundle install
ADD . /railsapp