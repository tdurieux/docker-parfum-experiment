FROM ruby:2.2.3

WORKDIR /truppie

RUN apt-get update \
&& apt-get install --no-install-recommends -y git \
&& curl -f -sL https://deb.nodesource.com/setup_8.x | bash - \
&& apt-get install --no-install-recommends -y nodejs \
&& gem install bundler && rm -rf /var/lib/apt/lists/*;

ADD . /truppie

RUN bundle install
