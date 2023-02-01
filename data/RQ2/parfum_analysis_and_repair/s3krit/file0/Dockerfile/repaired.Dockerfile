FROM ruby:2.7.1
ENV RACK_ENV production

RUN apt-get -y update; apt-get install --no-install-recommends -y imagemagick && rm -rf /var/lib/apt/lists/*;

# Copy and set up app
RUN mkdir /code
COPY . /code/

COPY Gemfile* /code/
WORKDIR /code
RUN bundle install

EXPOSE 9292
CMD rackup
