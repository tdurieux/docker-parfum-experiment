FROM ruby:2.5.1

RUN apt-get update -y && apt-get install --no-install-recommends -y build-essential sqlite3 apt-utils libpq-dev imagemagick curl socat && rm -rf /var/lib/apt/lists/*;
RUN curl -f --silent --location https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;

ENV RAILS_ROOT /rails

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT
ADD . $RAILS_ROOT

RUN bundle install --jobs 20 --retry 5

EXPOSE 3000
