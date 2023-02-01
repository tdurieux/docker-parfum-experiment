FROM ruby:2.2.0
RUN mkdir -p /usr/local/bundle
RUN apt-get update && apt-get -y --no-install-recommends install apt-utils nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
COPY . /usr/src/app
WORKDIR /usr/src/app
EXPOSE 3000

# RUN bundle update
RUN bundle install
