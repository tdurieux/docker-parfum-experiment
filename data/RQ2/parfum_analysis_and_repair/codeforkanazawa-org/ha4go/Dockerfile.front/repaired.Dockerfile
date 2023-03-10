FROM ha4go-base:1.0

RUN mkdir /myapp
WORKDIR /myapp

RUN apt-get install --no-install-recommends -y libmagickwand-dev tzdata && rm -rf /var/lib/apt/lists/*;

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle config without test development doc
RUN bundle install
ADD . /myapp/

# ADD .env /myapp/.env
ENV RAILS_ENV  production

EXPOSE 3000

CMD bash -l -c 'bundle exec rake assets:precompile && bundle exec rails s'
