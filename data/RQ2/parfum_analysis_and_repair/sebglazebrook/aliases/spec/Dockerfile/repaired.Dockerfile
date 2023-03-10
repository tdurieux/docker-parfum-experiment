FROM ruby:2.3

RUN apt-get update && apt-get install --no-install-recommends --yes apt-transport-https ca-certificates gnupg2 && rm -rf /var/lib/apt/lists/*;

RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install --no-install-recommends --yes docker-engine && rm -rf /var/lib/apt/lists/*;

RUN gem install bundler

WORKDIR /code

COPY Gemfile* /code/

RUN bundle install

COPY * /code/
