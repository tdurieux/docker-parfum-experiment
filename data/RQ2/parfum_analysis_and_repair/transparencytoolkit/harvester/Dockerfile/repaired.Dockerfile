FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libcurl3 libcurl3-gnutls libcurl4-openssl-dev libmagickcore-dev libmagickwand-dev mongodb && rm -rf /var/lib/apt/lists/*;
RUN mkdir /harvester
WORKDIR /harvester
ADD * /harvester/
RUN bundle install
ADD . /harvester