FROM ruby:2.5.0

RUN \
	apt-get update && \
	apt-get -y --no-install-recommends install chromedriver && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
COPY Gemfile* /usr/src/app/
RUN bundle install
COPY . /usr/src/app

CMD ["bin/start"]
