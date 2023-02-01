FROM ubuntu:18.04

RUN mkdir /app
WORKDIR /app

RUN apt update
RUN apt install --no-install-recommends build-essential openssl curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison --yes && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends mysql-client --yes && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends ruby-full --yes && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends libmysqlclient-dev ruby-dev --yes && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler

COPY Gemfile /app
RUN bundle install