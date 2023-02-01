FROM jruby:1.7

MAINTAINER opensource@groupon.com

RUN apt-get -q update && apt-get -q --no-install-recommends -q -y install git && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app

ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN bundle install --without development torquebox

ADD . /app
