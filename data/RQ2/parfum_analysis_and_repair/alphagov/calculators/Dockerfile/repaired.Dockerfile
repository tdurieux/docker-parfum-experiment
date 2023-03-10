FROM ruby:2.7.2
RUN apt-get update -qq && apt-get upgrade -y

RUN apt-get install --no-install-recommends -y build-essential nodejs && apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV GOVUK_APP_NAME calculators
ENV PORT 3047
ENV RAILS_ENV development

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
ADD .ruby-version $APP_HOME/
RUN bundle install

ADD . $APP_HOME

RUN GOVUK_WEBSITE_ROOT=https://www.gov.uk GOVUK_APP_DOMAIN=www.gov.uk RAILS_ENV=production bundle exec rails assets:precompile

CMD bash -c "bundle exec rails s -p $PORT -b '0.0.0.0'"
