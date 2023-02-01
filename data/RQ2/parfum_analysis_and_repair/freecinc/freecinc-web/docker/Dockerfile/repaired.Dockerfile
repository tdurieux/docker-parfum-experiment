FROM ruby:2.6

# happily, the latest taskd is packaged upstream; we need gnutls-bin
# to generate client certs
RUN apt-get update && apt-get install --no-install-recommends -y gnutls-bin taskd && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /app
WORKDIR /app
ADD app.tar /app/
RUN bundle install
EXPOSE 80
CMD bundle exec rackup config-freecinc.ru -p 80 -o 0.0.0.0
